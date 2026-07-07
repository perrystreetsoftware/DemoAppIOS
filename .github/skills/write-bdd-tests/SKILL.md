---
name: write-bdd-tests
description: Guides writing BDD unit tests using Quick/Nimble framework with proper mock setup and DI. Use this when asked to write tests, create a ViewModel test, fix a failing test, or implement Given/When/Then tests.
---

You are writing unit tests for the TravelAdvisories (DemoAppIOS) project. Tests use Quick (BDD) and Nimble (matchers) with Swinject dependency injection, plus Gherkin-style `Given`/`When`/`And`/`Then` helpers from `UtilsTestExtensions` and Combine stream assertions via `CombineExpectations` recorders.

## File Location

Tests live inside each package, mirroring the source target:

```
Source: Packages/<Package>/Sources/<Target>/<Name>.swift
Test:   Packages/<Package>/Tests/<Target>Tests/<Name>Tests.swift
```

For example: `Packages/ViewModels/Sources/ViewModels/CountryListViewModel.swift` → `Packages/ViewModels/Tests/ViewModelsTests/CountryListViewModelTests.swift`

## Test Structure Template

This is a trimmed, real test from the project (`CountryListViewModelTests`):

```swift
import Quick
import Nimble
import Swinject
import Foundation
import DomainModels
import CombineExpectations
import Interfaces
import InterfaceMocks
import Logic
import Combine
import UtilsTestExtensions
import SwinjectAutoregistration
import Repositories

@testable import ViewModels
import FrameworkProviderTestFactories

final class CountryListViewModelTests: QuickSpec {
    override class func spec() {
        describe("CountryListViewModelTests") {
            var container: Container!
            var viewModel: CountryListViewModel!
            var api: MockTravelAdvisoryApi!
            let countryToBeReturned = PassthroughSubject<CountryListDTO, TravelAdvisoryApiError>()
            var stateRecorder: Recorder<CountryListUiState, Never>!

            beforeEach {
                container = Container().injectRepositories()
                    .injectLogic()
                    .injectViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                    .injectFrameworkProviderFacades()
                    .injectFrameworkProviderMocks()

                TimeAdvancingFactory(container).save()

                api = container~>
                api.getCountryListPublisher = countryToBeReturned.eraseToAnyPublisher()

                viewModel = container~>
                stateRecorder = viewModel.$state.record()
            }

            When("a country is returned") {
                var states: [CountryListUiState]!

                beforeEach {
                    countryToBeReturned.send(.init())
                    countryToBeReturned.send(completion: .finished)

                    states = try! stateRecorder.availableElements.get()
                }

                Then("we should emit a loading and a loaded state") {
                    expect(states[2].isLoading).to(beFalse())
                    expect(states[2].isLoaded).to(beTrue())
                }
            }

            When("I request location permissions") {
                var locationStateRecorder: Recorder<LocationUiState, Never>!

                justBeforeEach {
                    viewModel.onRefreshLocationTap()
                    locationStateRecorder = viewModel.$state.map { $0.yourLocation }.record()
                }

                And("It is authorized") {
                    beforeEach {
                        LocationFacadeTestFactory(container)
                            .withLocationAuthorizedAlways()
                            .withNextLocationEmpireState()
                    }

                    And("We receive a location after a second") {
                        justBeforeEach {
                            TimeAdvancingFactory(container).advance(by: 1.0).save()
                        }

                        Then("We get a new location") {
                            expect(locationStateRecorder.allElementsDescription) == [
                                "updating",
                                "location:40.748817,-73.985428"
                            ]
                        }
                    }
                }
            }
        }
    }
}
```

## Critical Rules

### Execution Order
- `beforeEach` runs **top-down through the nesting hierarchy** — use it for **setting up the container, mocks, and factories**
- `justBeforeEach` runs **after all `beforeEach` blocks** — use it for **triggering actions** (e.g., `viewModel.onRefreshLocationTap()`)
- This separation ensures state is configured before the code under test acts on it
- Do not trigger actions inside a `Then` block — move them to a `justBeforeEach` in a `When`/`And` context

### DI Container
There is no single `injectForTests()` helper — chain the injection extensions for the layers your test needs, always mixing real logic with mock APIs and mock framework providers:

| Layer under test | Typical chain |
| ---------------- | ------------- |
| Repository | `Container().injectRepositories().injectInterfaceLocalMocks().injectInterfaceRemoteMocks()` |
| Logic | ...add `.injectLogic()` |
| ViewModel | ...add `.injectViewModels().injectFrameworkProviderFacades().injectFrameworkProviderMocks()` |

- Resolve dependencies with the `container~>` operator (SwinjectAutoregistration)
- Injection extensions live in each package's `DI/Container+*.swift` files

### Mocks, Factories, and Schedulers
- **Mock API**: `MockTravelAdvisoryApi` (from `InterfaceMocks`) — drive it with `PassthroughSubject`s assigned to its `*Publisher` properties, then `send(...)` values/completions from `beforeEach` blocks. Setting plain `*Result` state on mock APIs from tests is flagged by the `DoNotUseMockApisForSettingState` lint rule (existing tests are baselined; prefer factories for new setup helpers).
- **Test factories** (in `FrameworkProviderTestFactories`):
  - `TimeAdvancingFactory(container).save()` — installs a `TestScheduler` so time is virtual; advance it with `.advance(by: seconds).save()`
  - `LocationFacadeTestFactory(container)` — builder for location mock state (`.withLocationAuthorizedAlways()`, `.withLocationStatusDenied()`, `.withNextLocationEmpireState()`, ...)
- Never use real time (`waitUntil`, `sleep`, `DispatchQueue.asyncAfter`) — advance the test scheduler instead

### Assertions
- Record Combine streams: `recorder = viewModel.$state.record()` (CombineExpectations `Recorder`)
- Already-emitted values: `try! recorder.availableElements.get()`
- Compact stream assertions: `expect(recorder.allElementsDescription) == ["updating", "error"]` (uses each element's `description`)
- Waiting helpers from `UtilsTestExtensions`: `waitNext(recorder)`, `waitNext(recorder, count: 2)`, `waitCompletion(publisher)` — all accept an optional `TestScheduler` to advance first
- Direct value assertions: `expect(states[2].isLoaded).to(beTrue())`, `expect(value.count).to(equal(0))`, `expect(completion) == .finished`

### Prohibited Patterns
- **No focused tests** (`fThen`, `fWhen`, `fAnd`, `fGiven`, `fit`, `fcontext`, `fdescribe`) — a single focused example silently skips every other test in the bundle. A committed `fThen` once kept 4 of 5 `CountryListViewModelTests` cases from running. Enforced by the `DoNotUseFocusedTests` lint rule.
- **No mock API state-setting** in tests (`api.something = ...` for state) — use factories or publisher subjects. Enforced by `DoNotUseMockApisForSettingState`.
- **No actions inside `Then` blocks** — trigger in `justBeforeEach`, assert in `Then`.
- **No real timers/sleeps** — use `TimeAdvancingFactory`.

#### Bad example

```swift
Then("We get a new location") {
    viewModel.onRefreshLocationTap()          // action inside Then
    sleep(1)                                  // real time
    expect(viewModel.state.yourLocation).toNot(beNil())
}
```

#### Good example

```swift
When("I request location permissions") {
    justBeforeEach {
        viewModel.onRefreshLocationTap()
    }

    And("We receive a location after a second") {
        justBeforeEach {
            TimeAdvancingFactory(container).advance(by: 1.0).save()
        }

        Then("We get a new location") {
            expect(locationStateRecorder.allElementsDescription).toNot(beEmpty())
        }
    }
}
```

## Which Tests to Run for Which Change

| You changed | Run (via the `run-unit-tests` skill) |
| ----------- | ------------------------------------ |
| A ViewModel | `ViewModelsTests` |
| A Logic class | `LogicTests`, then `ViewModelsTests` |
| A Repository | `RepositoriesTests`, then `LogicTests` and `ViewModelsTests` |
| Interfaces / DTOs / mock APIs | `RepositoriesTests`, `LogicTests`, `ViewModelsTests` |
| FrameworkProviders / facades | `FrameworkProviderTests`, then `ViewModelsTests` |
| Feature (screens, adapters) | `FeatureTests` (requires the iOS simulator) |
| UIComponents | `UIComponentsTests` (requires the iOS simulator) |
| DomainModels | Everything (`run-tests.sh` with no arguments) |
| A lint rule | Use the `run-harmonize` skill instead |

After writing a test, run it with the `run-unit-tests` skill and confirm it passes. If a test fails, decide whether the test or the underlying code is wrong; if unclear, ask the user which approach to take.
