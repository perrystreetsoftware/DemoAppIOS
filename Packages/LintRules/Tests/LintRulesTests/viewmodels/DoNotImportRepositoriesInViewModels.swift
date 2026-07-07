//
//  DoNotImportRepositoriesInViewModels.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotImportRepositoriesInViewModels: QuickSpec {
    override class func spec() {
        Given("A ViewModel source file in production") {
            let viewModelFiles = HarmonizeTravelAdvisories.viewModelsPackage
                .sources()

            Then("It does not import Repositories") {
                viewModelFiles.assertFalse(message: message) {
                    $0.imports().contains { $0.name == "Repositories" }
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "ViewModels may not import Repositories.",
        why: """
            Importing Repositories from a ViewModel violates separation of concerns: the \
            Logic layer exists to encapsulate repository access, business rules, and error \
            mapping. A Repositories import in a ViewModel is a sign that a Logic class is \
            being skipped.
            """,
        howToFix: """
            Access repository data through a Logic class and import Logic instead.
            """,
        badExample: """
            import Repositories

            public final class CountryListViewModel: ObservableObject {
                private let repository: CountryListRepository
            }
            """,
        goodExample: """
            import Logic

            public final class CountryListViewModel: ObservableObject {
                private let logic: CountryListLogic
            }
            """
    )
}
