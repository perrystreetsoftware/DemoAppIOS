//
//  DoNotImportFrameworkProviderProtocols.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotImportFrameworkProviderProtocols: QuickSpec {
    override class func spec() {
        Given("A ViewModel") {
            let viewModels = HarmonizeTravelAdvisories
                .viewModelsPackage
                .sources()

            Then("It does not depend on FrameworkProviderProtocols") {
                viewModels
                    .withImport("FrameworkProviderProtocols")
                    .assertEmpty(message: message)
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "ViewModels must not import FrameworkProviderProtocols.",
        why: """
            FrameworkProviderProtocols should not be imported by any layer besides Logic \
            and Repositories. ViewModels that talk to framework providers directly bypass \
            the layers that make that access testable and consistent.
            """,
        howToFix: """
            Route framework access through a Logic class. If you only need the model types, \
            import FrameworkProviderProtocolModels instead.
            """,
        badExample: """
            import FrameworkProviderProtocols

            public final class CountryListViewModel: ObservableObject {
                private let locationProvider: LocationProviding
            }
            """,
        goodExample: """
            import FrameworkProviderProtocolModels

            public final class CountryListViewModel: ObservableObject {
                private let currentLocationLogic: GetCurrentLocationLogic
                @Published public var location: PSSLocation? = nil
            }
            """
    )
}
