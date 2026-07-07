#!/bin/bash
#
# run-tests.sh
#
# Runs DemoAppIOS unit tests. Only prints pass/fail result and failure details.
# By default runs every package test target EXCEPT LintRulesTests (the Harmonize
# lint rules have their own runner: .github/skills/run-harmonize/run-harmonize.sh).
#
# Most packages build and run natively on macOS (swift build + xcrun xctest).
# FeatureTests and UIComponentsTests depend on UIKit-only libraries
# (MarqueeLabel/SnapKit), so they run on the iOS Simulator through the app
# scheme's test plan instead.
#
# Usage:
#   bash .github/skills/run-unit-tests/run-tests.sh                              # everything
#   bash .github/skills/run-unit-tests/run-tests.sh CountryListViewModelTests    # one class (auto-detected)
#   bash .github/skills/run-unit-tests/run-tests.sh ClassA ClassB                # several classes
#   bash .github/skills/run-unit-tests/run-tests.sh --target ViewModelsTests     # a whole target
#   bash .github/skills/run-unit-tests/run-tests.sh --target LogicTests RepositoriesTests

set -o pipefail

cd "$(dirname "$0")/../../.." || exit 1

PROJECT="TravelAdvisories.xcodeproj"
APP_SCHEME="TravelAdvisories (iOS)"

# Test targets that cannot build natively on macOS (UIKit-only dependencies).
SIMULATOR_TARGETS="FeatureTests UIComponentsTests"

LOGDIR=$(mktemp -d /tmp/run-tests.XXXXXX)
trap 'rm -rf "$LOGDIR"' EXIT

TOTAL_TESTS=0
TOTAL_FAILS=0
OVERALL_EXIT=0

is_simulator_target() {
    case " $SIMULATOR_TARGETS " in
        *" $1 "*) return 0 ;;
        *) return 1 ;;
    esac
}

# Target name (e.g. ViewModelsTests) -> package dir name (e.g. ViewModels)
pkg_for_target() {
    local d
    d=$(ls -d Packages/*/Tests/"$1" 2>/dev/null | head -1)
    [ -n "$d" ] && echo "$d" | cut -d/ -f2
}

# Class name -> "package target" (auto-detection). Excludes LintRules.
locate_class() {
    local file
    file=$(find Packages/*/Tests -name "$1.swift" -not -path "*LintRules*" 2>/dev/null | head -1)
    if [ -z "$file" ]; then
        file=$(grep -rl --include='*.swift' "class $1" Packages/*/Tests 2>/dev/null | grep -v LintRules | head -1)
    fi
    [ -z "$file" ] && return 1
    echo "$file" | awk -F/ '{print $2" "$4}'
}

# Print only real test failures from a log, grouped by test class:
#   Test Class: <Module.Class>
#     - <test name>: <message>
#       at <file:line>
print_clean_failures() {
    local structured
    structured=$(grep -E ": (fatal )?error:" "$1" 2>/dev/null \
    | grep -v "^$" \
    | sed -n 's/^\(.*\): error: -\[\([^ ]*\) \([^]]*\)\] : \(.*\)/\2'$'\t''\3'$'\t''\1'$'\t''\4/p' \
    | awk -F'\t' '
    {
        tc = $1; method = $2; loc = $3; msg = $4
        if (!(tc in seen)) { seen[tc] = 1; order[++n] = tc }
        fails[tc] = fails[tc] "  - " method ": " msg "\n    at " loc "\n"
    }
    END {
        for (i = 1; i <= n; i++) {
            print "Test Class: " order[i]
            printf "%s", fails[order[i]]
            print ""
        }
    }')

    if [ -n "$structured" ]; then
        printf '%s\n' "$structured"
    else
        # No assertion failures matched — likely a compile/build error.
        grep -E ": (fatal )?error:" "$1" 2>/dev/null | grep -v "^$" | sort -u | head -30
    fi
}

# Count executed/failed test cases in a log and add to totals.
# Counts "Test Case ... passed/failed" lines directly: xcodebuild logs contain
# one "Executed N tests" summary per bundle, so summary lines cannot be
# aggregated reliably.
collect_result() {
    local log="$1" label="$2" exit_code="$3" expected_filter="$4"
    local tests fails skipped
    tests=$(grep -cE "Test Case .* (passed|failed) \(" "$log")
    fails=$(grep -cE "Test Case .* failed \(" "$log")
    skipped=$(grep -cE "Test Case .* skipped \(" "$log")

    if ! grep -qE "Executed [0-9]+ tests?," "$log"; then
        echo "[$label] BUILD/RUN FAILURE — tests did not run."
        print_clean_failures "$log"
        OVERALL_EXIT=1
        return
    fi

    if [ "${skipped:-0}" != "0" ]; then
        echo "[$label] WARNING: $skipped test(s) skipped — check for committed focused tests (fThen/fWhen/fcontext)."
    fi

    if [ -n "$expected_filter" ] && [ "$tests" = "0" ]; then
        echo "[$label] ERROR: filter '$expected_filter' matched no tests."
        OVERALL_EXIT=1
        return
    fi

    TOTAL_TESTS=$((TOTAL_TESTS + tests))
    TOTAL_FAILS=$((TOTAL_FAILS + fails))
    echo "[$label] executed $tests tests, $fails failures"

    if [ "$exit_code" -ne 0 ] || [ "$fails" != "0" ]; then
        OVERALL_EXIT=1
        echo ""
        print_clean_failures "$log"
    fi
}

# Run a native (macOS) package bundle, optionally filtered to one class.
run_native() {
    local pkg="$1" klass="$2"
    local label="${pkg}${klass:+/$klass}"
    local log="$LOGDIR/native-$pkg${klass:+-$klass}.log"

    if ! swift build --package-path "Packages/$pkg" --build-tests > "$log" 2>&1; then
        echo "[$label] BUILD FAILURE — tests did not compile."
        grep -E "error:" "$log" | head -20
        OVERALL_EXIT=1
        return
    fi

    local bundle="Packages/$pkg/.build/debug/${pkg}PackageTests.xctest"
    local cmd=(xcrun xctest)
    [ -n "$klass" ] && cmd+=(-XCTest "$klass")
    cmd+=("$bundle")

    "${cmd[@]}" > "$log" 2>&1
    collect_result "$log" "$label" $? "$klass"
}

# Run one xcodebuild invocation on the iOS Simulator via the app scheme's
# test plan. Arguments are -only-testing specs (Target or Target/Class).
run_simulator() {
    local log="$LOGDIR/simulator.log"

    local sim
    sim=$(xcrun simctl list devices booted -j 2>/dev/null \
        | grep -oE '"udid" : "[A-F0-9-]+"' | head -1 | grep -oE '[A-F0-9-]{36}')
    if [ -z "$sim" ]; then
        sim=$(xcrun simctl list devices available 2>/dev/null \
            | grep -E '^[[:space:]]+iPhone' | head -1 | grep -oE '[A-F0-9-]{36}' | head -1)
    fi
    if [ -z "$sim" ]; then
        echo "[simulator] No iOS simulator available. Boot one (xcrun simctl boot <UDID>) and retry."
        OVERALL_EXIT=1
        return
    fi

    local cmd=(xcodebuild test
        -project "$PROJECT"
        -scheme "$APP_SCHEME"
        -destination "platform=iOS Simulator,id=$sim"
    )
    local spec
    for spec in "$@"; do
        cmd+=(-only-testing:"$spec")
    done

    echo "[simulator] Running $* on the iOS Simulator (this builds the app)..."
    "${cmd[@]}" > "$log" 2>&1
    collect_result "$log" "simulator:$*" $? "$*"
}

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
MODE="classes"
TARGETS=()
CLASSES=()
for arg in "$@"; do
    case "$arg" in
        --target|--package) MODE="targets" ;;
        -h|--help)
            sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            if [ "$MODE" = "targets" ]; then
                TARGETS+=("$arg")
            else
                CLASSES+=("$arg")
            fi
            ;;
    esac
done

# Normalize: allow package names (ViewModels) as well as target names (ViewModelsTests)
normalize_target() {
    if [ -n "$(pkg_for_target "$1")" ]; then
        echo "$1"
    elif [ -d "Packages/$1/Tests" ]; then
        ls "Packages/$1/Tests" | head -1
    fi
}

echo "Running unit tests..."
echo "---"

SIM_SPECS=()

if [ ${#CLASSES[@]} -gt 0 ]; then
    # --- Specific class(es), auto-detect their package/target ---
    for klass in "${CLASSES[@]}"; do
        located=$(locate_class "$klass")
        if [ -z "$located" ]; then
            echo "ERROR: could not find test class '$klass' under Packages/*/Tests (LintRules excluded — use run-harmonize for lint rules)."
            OVERALL_EXIT=1
            continue
        fi
        pkg=$(echo "$located" | cut -d' ' -f1)
        target=$(echo "$located" | cut -d' ' -f2)
        echo "[detect] $klass -> package $pkg, target $target"
        if is_simulator_target "$target"; then
            SIM_SPECS+=("$target/$klass")
        else
            run_native "$pkg" "$klass"
        fi
    done
elif [ ${#TARGETS[@]} -gt 0 ]; then
    # --- Whole target(s) ---
    for t in "${TARGETS[@]}"; do
        target=$(normalize_target "$t")
        if [ -z "$target" ]; then
            echo "ERROR: unknown test target or package '$t'."
            OVERALL_EXIT=1
            continue
        fi
        if is_simulator_target "$target"; then
            SIM_SPECS+=("$target")
        else
            run_native "$(pkg_for_target "$target")"
        fi
    done
else
    # --- Everything (excluding LintRules) ---
    for tests_dir in Packages/*/Tests; do
        pkg=$(echo "$tests_dir" | cut -d/ -f2)
        [ "$pkg" = "LintRules" ] && continue
        target=$(ls "$tests_dir" | head -1)
        if is_simulator_target "$target"; then
            SIM_SPECS+=("$target")
        else
            run_native "$pkg"
        fi
    done
fi

if [ ${#SIM_SPECS[@]} -gt 0 ]; then
    run_simulator "${SIM_SPECS[@]}"
fi

echo "---"
echo "Executed $TOTAL_TESTS tests, with $TOTAL_FAILS failures."
if [ $OVERALL_EXIT -eq 0 ]; then
    echo "TESTS PASSED"
else
    echo "TESTS FAILED"
fi
exit $OVERALL_EXIT
