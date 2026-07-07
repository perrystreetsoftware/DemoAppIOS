//
//  DoesNotAllowMocksInTests.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoesNotAllowMocksInTests: QuickSpec {
    private static let mockingLibraries = ["OCMock", "Cuckoo", "SwiftyMocky", "Mockingbird"]

    override class func spec() {
        Given("A test source file") {
            let testSources = HarmonizeTravelAdvisories.testCode.sources()

            Then("It does not import a mocking library") {
                testSources.assertFalse(message: message) { source in
                    source.imports().contains { mockingLibraries.contains($0.name) }
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Tests must not import mocking libraries.",
        why: """
            This project tests against its own fake layer (MockTravelAdvisoryApi in \
            InterfaceMocks, FrameworkProviderMocks) wired through the DI container. \
            Mocking frameworks (OCMock, Cuckoo, SwiftyMocky, Mockingbird) couple tests \
            to implementation internals, encourage stubbing per-test instead of modeling \
            behavior, and drift from how the app actually wires its dependencies.
            """,
        howToFix: """
            Inject the existing mock modules through the container \
            (`.injectInterfaceLocalMocks().injectInterfaceRemoteMocks()\
            .injectFrameworkProviderMocks()`) and drive them with publishers or test \
            factories instead of a mocking framework.
            """,
        badExample: """
            import Cuckoo

            let api = MockTravelAdvisoryApiImplementing()
            stub(api) { stub in
                when(stub.getCountryList()).thenReturn(...)
            }
            """,
        goodExample: """
            import InterfaceMocks

            api = container~>
            api.getCountryListPublisher = countryToBeReturned.eraseToAnyPublisher()
            """
    )
}
