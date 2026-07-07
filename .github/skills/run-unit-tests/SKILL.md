---
name: run-unit-tests
description: Runs unit tests and guides fixing failures. Use when asked to run tests, verify changes with tests, or debug test failures.
---

You are running unit tests for the TravelAdvisories (DemoAppIOS) project. Tests use the Quick/Nimble BDD framework and live inside each SPM package under `Packages/`.

> **Note:** Unit tests require macOS with Xcode. Test targets depend on Apple's Combine framework, and two targets additionally require the iOS Simulator.

## How to Run

```bash
# Run ALL package tests (default — excludes the Harmonize lint rules)
bash .github/skills/run-unit-tests/run-tests.sh

# Run a specific test class — the script auto-detects its package/target
bash .github/skills/run-unit-tests/run-tests.sh CountryListViewModelTests

# Run multiple classes
bash .github/skills/run-unit-tests/run-tests.sh CountryListLogicTests LocationRepositoryTests

# Run one or more whole targets (package names also accepted)
bash .github/skills/run-unit-tests/run-tests.sh --target ViewModelsTests
bash .github/skills/run-unit-tests/run-tests.sh --target LogicTests RepositoriesTests
```

Always use the helper script instead of calling `xcodebuild` or `swift test` directly — it picks the right execution path per target, filters thousands of lines of build noise, and prints a clear `TESTS PASSED` / `TESTS FAILED` summary with failure details.

**Why not `swift test`:** `swift test --filter` cannot see Quick's dynamically generated tests (it silently runs 0 tests). The script instead builds with `swift build --build-tests` and runs the bundle via `xcrun xctest`, using `-XCTest <ClassName>` for class filters.

**Lint rules are separate:** `LintRulesTests` (Harmonize architectural rules) is intentionally excluded — run those with the `run-harmonize` skill.

## Execution Paths

| Path | Targets | Mechanism |
|------|---------|-----------|
| Native macOS (fast) | everything else | `swift build --package-path Packages/<Pkg> --build-tests` + `xcrun xctest` |
| iOS Simulator | `FeatureTests`, `UIComponentsTests` | `xcodebuild test -scheme "TravelAdvisories (iOS)"` with `-only-testing:` filters (these packages depend on UIKit-only libraries — MarqueeLabel/SnapKit — and cannot build natively on macOS; their standalone package schemes have no test bundles, so the app scheme's test plan `Shared/TestPlan.xctestplan` is used) |

The simulator path builds the whole app once, so it is much slower — prefer class- or target-scoped runs while iterating on anything outside Feature/UIComponents.

## Long-Running Reliability

| Rule | Detail |
|------|--------|
| Mode | Use `sync` mode with `timeout=0` so the call blocks until the script exits |
| Progress | Do not poll with `ps`; wait for the final summary |
| Exit code | The script's exit code and summary line are the source of truth |
| Truncated output | If output looks truncated but an exit code is present, trust the exit code — do not rerun |
| No trailing probes | Do not append `; echo $?` or `; echo EXIT_CODE:$?` to `run-tests.sh` |
| No reruns | Do not rerun the script if the previous invocation already produced a known exit code |

## Test Targets

| Target | Package | What it covers |
|--------|---------|----------------|
| `ViewModelsTests` | ViewModels | ViewModel state machines |
| `LogicTests` | Logic | Business logic / use cases |
| `RepositoriesTests` | Repositories | Data access layer |
| `NetworkLogicTests` | NetworkLogic | Network API implementation |
| `FrameworkProviderTests` | FrameworkProviders | Provider facades (location, schedulers) |
| `DomainModelsTests` | DomainModels | Domain model tests |
| `FeatureTests` | Feature | Screens/adapters (iOS Simulator) |
| `UIComponentsTests` | UIComponents | UI components (iOS Simulator) |
| `UtilsTests` | Utils | Utility functions |
| `DITests` | DI | DI macros (@Factory/@Single) |
| `LintRulesTests` | LintRules | Harmonize lint rules — excluded; use `run-harmonize` |

The app-level Xcode targets (`Tests iOS`, `TravelAdvisoriesTestsObjc`) are legacy app-hosted smoke tests and are not part of the script's scope.

## Finding Test Files

Tests mirror the source structure within each package:

```
Source: Packages/<Package>/Sources/<Target>/<Name>.swift
Test:   Packages/<Package>/Tests/<Target>Tests/<Name>Tests.swift
```

## Key Testing Conventions

- **DI Container**: Tests chain injection extensions — e.g. `Container().injectRepositories().injectLogic().injectViewModels().injectInterfaceLocalMocks().injectInterfaceRemoteMocks().injectFrameworkProviderFacades().injectFrameworkProviderMocks()` — injecting real Logic/Repositories/ViewModels but mock APIs and mock framework providers. Resolve with `container~>`.
- **Mock state**: Drive `MockTravelAdvisoryApi` through `PassthroughSubject` publishers; use `TimeAdvancingFactory` / `LocationFacadeTestFactory` for scheduler and location state (see the `write-bdd-tests` skill).
- **Assertions**: CombineExpectations recorders (`viewModel.$state.record()`), `expect(recorder.allElementsDescription) == [...]`, and the `waitNext`/`waitCompletion` helpers from `UtilsTestExtensions`.
- **Interpreting failures**: The failure summary shows `Test Class`, the Gherkin-style test name, the Nimble message, and the `file:line` of the failing expectation.
- **Focused tests**: If a run reports fewer tests than expected or "skipped" cases, look for committed `fThen`/`fWhen`/`fcontext` — a single focused example silently skips the rest of the bundle (also enforced by the `DoNotUseFocusedTests` lint rule).
- **Fixing tests vs fixing code**: If a test is failing, decide whether to fix the test or the underlying code. If it is not clear whether the test is accurate, ask the user which approach to take.
