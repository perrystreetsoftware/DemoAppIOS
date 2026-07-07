#!/bin/bash
#
# run-harmonize.sh
#
# Runs Harmonize architectural lint rules and filters the output
# to show only failures. This prevents filling the agent's context
# window with thousands of lines of verbose build logs.
#
# Usage:
#   bash .github/skills/run-harmonize/run-harmonize.sh              # Run all rules
#   bash .github/skills/run-harmonize/run-harmonize.sh RuleName      # Run one rule
#   bash .github/skills/run-harmonize/run-harmonize.sh Rule1 Rule2   # Run multiple rules

set -o pipefail

# IMPORTANT: Harmonize resolves `.harmonize.yaml` excludes against the test
# process working directory. Tests MUST run with CWD at the repo root —
# running from inside Packages/LintRules makes every scanned file appear to
# live under "LintRules" and the exclude list empties the whole scan.
cd "$(dirname "$0")/../../.." || exit 1

PACKAGE_DIR="Packages/LintRules"
TEST_BUNDLE="$PACKAGE_DIR/.build/debug/LintRulesPackageTests.xctest"

TMPFILE=$(mktemp /tmp/harmonize-output.XXXXXX)
trap 'rm -f "$TMPFILE"' EXIT

# Emit ::error annotations so GitHub Actions shows inline PR comments.
# Works for both Linux and macOS error line formats.
emit_github_annotations() {
    [ -n "$GITHUB_ACTIONS" ] || return

    # Resolve workspace path for stripping absolute paths to relative
    local ws="${GITHUB_WORKSPACE%/}"

    grep -E ": error: .*: failed -" "$TMPFILE" \
    | while IFS= read -r line; do
        file=$(echo "$line" | sed -n 's/^\(.*\):[0-9]*: error:.*/\1/p')
        lineno=$(echo "$line" | sed -n 's/^.*:\([0-9]*\): error:.*/\1/p')
        msg=$(echo "$line" | sed -n 's/^.*: error: .*: failed - *\(.*\)/\1/p')
        # Make path relative so GitHub Actions can attach annotations to PR files
        file="${file#"$ws"/}"
        # Escape %, \r, \n for GitHub Actions workflow commands
        file=$(printf '%s' "$file" | sed -e 's/%/%25/g' -e 's/\r/%0D/g' -e 's/\n/%0A/g')
        msg=$(printf '%s' "$msg" | sed -e 's/%/%25/g' -e 's/\r/%0D/g' -e 's/\n/%0A/g')
        # Skip the lint rule definition file itself (self-referential error)
        if echo "$file" | grep -qv "LintRulesTests"; then
            echo "::error file=$file,line=$lineno::$msg"
        fi
    done
}

echo "Running Harmonize lint rules..."
if [ $# -gt 0 ]; then
    echo "Rules: $*"
fi
echo "---"

# Step 1: Build tests (from repo root; --package-path keeps CWD here)
echo "Building tests..."
swift build --package-path "$PACKAGE_DIR" --build-tests > "$TMPFILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    echo "BUILD FAILURE — tests did not compile."
    echo ""
    grep -E "error:" "$TMPFILE" | head -50
    exit $EXIT_CODE
fi

# Step 2: Run tests from the repo root (CWD must be repo root for Harmonize)
: > "$TMPFILE"
EXIT_CODE=0

if [ "$(uname)" = "Linux" ]; then
    # On Linux the .xctest bundle is the binary itself, and
    # swift-corelibs-xctest supports a single --filter regex.
    if [ ! -f "$TEST_BUNDLE" ]; then
        echo "ERROR: Test binary not found at $TEST_BUNDLE"
        exit 1
    fi

    CMD=("$TEST_BUNDLE")
    if [ $# -gt 0 ]; then
        FILTER_PATTERN=$(printf "%s|" "$@")
        FILTER_PATTERN="${FILTER_PATTERN%|}"  # Remove trailing pipe
        CMD+=(--filter "$FILTER_PATTERN")
    fi

    "${CMD[@]}" >> "$TMPFILE" 2>&1
    EXIT_CODE=$?
else
    # On macOS the .xctest bundle is a directory; run it via `xcrun xctest`.
    # xctest accepts a single -XCTest filter, so run once per requested rule.
    if [ ! -d "$TEST_BUNDLE" ]; then
        echo "ERROR: Test bundle not found at $TEST_BUNDLE"
        exit 1
    fi

    if [ $# -gt 0 ]; then
        for rule in "$@"; do
            xcrun xctest -XCTest "$rule" "$TEST_BUNDLE" >> "$TMPFILE" 2>&1
            RULE_EXIT=$?
            [ $RULE_EXIT -ne 0 ] && EXIT_CODE=$RULE_EXIT
        done
    else
        xcrun xctest "$TEST_BUNDLE" >> "$TMPFILE" 2>&1
        EXIT_CODE=$?
    fi
fi

# Check if tests ran
if ! grep -qE "Test Suite .* passed|Test Suite .* failed|Executed .* test" "$TMPFILE"; then
    echo "RUN FAILURE — tests did not run."
    echo ""
    grep -E "error:" "$TMPFILE" | head -50
    exit $EXIT_CODE
fi

if [ $EXIT_CODE -eq 0 ]; then
    grep -E "Executed .* test" "$TMPFILE" | tail -1
    echo ""
    echo "HARMONIZE LINT RULES PASSED"
    exit 0
fi

# Show failures grouped by rule.
# macOS format: /path/File.swift:LINE: error: -[LintRulesTests.RuleName ...] : failed - MESSAGE
# Linux format: /path/File.swift:LINE: error: QuickSpec.DESCRIPTION : failed - MESSAGE
echo "FAILURES:"
echo ""

if [ "$(uname)" = "Linux" ]; then
    grep -E ": error: .*: failed -" "$TMPFILE" \
    | sed -n 's/^\(.*\): error: .*: failed - *\(.*\)/\2	\1/p' \
    | awk -F'\t' '
    {
        message = $1
        violation = $2

        if (!(message in order_idx)) {
            order_idx[message] = ++count
            order[count] = message
        }
        # Extract rule name from the test file path
        if (violation ~ /LintRulesTests/) {
            n = split(violation, parts, "/")
            fname = parts[n]
            sub(/\.swift.*/, "", fname)
            rules[message] = fname
        } else {
            violations[message] = violations[message] "  - " violation "\n"
        }
    }
    END {
        for (i = 1; i <= count; i++) {
            m = order[i]
            if (rules[m] != "") {
                print "Rule: " rules[m]
                print "  " m
            } else {
                print "Violation: " m
            }
            if (violations[m] != "") {
                print "  Violations:"
                printf "%s", violations[m]
            }
            print ""
        }
    }
    '
else
    grep -E ": error: -\[" "$TMPFILE" \
    | sed -n 's/^\(.*\): error: -\[LintRulesTests\.\([^ ]*\) .*\] : failed - *\(.*\)/\2	\1	\3/p' \
    | awk -F'\t' '
    {
        rule = $1
        violation = $2
        message = $3

        if (!(rule in messages)) {
            messages[rule] = message
            order[++count] = rule
        }
        # Collect violations, skip ones pointing to the test file itself
        if (violation !~ /LintRulesTests/) {
            violations[rule] = violations[rule] "  - " violation "\n"
        }
    }
    END {
        for (i = 1; i <= count; i++) {
            r = order[i]
            print "Rule: " r
            print "  " messages[r]
            if (violations[r] != "") {
                print "  Violations:"
                printf "%s", violations[r]
            }
            print ""
        }
    }
    '
fi

emit_github_annotations

echo "---"
grep -E "Executed .* test" "$TMPFILE" | tail -1
exit $EXIT_CODE
