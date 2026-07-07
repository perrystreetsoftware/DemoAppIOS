//
//  StandardNameForCancellables.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class StandardNameForCancellables: QuickSpec {
    override class func spec() {
        Given("A ViewModel or Repository class in production") {
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction
            let repositories = HarmonizeTravelAdvisories.repositoriesProduction

            Then("ViewModel cancellables use the standard name") {
                viewModels
                    .variables()
                    .withNameContaining("ancellables")
                    .assertTrue(message: message) { $0.name == "cancellables" }
            }

            Then("Repository cancellables use the standard name") {
                repositories
                    .variables()
                    .withNameContaining("ancellables")
                    .assertTrue(message: message) { $0.name == "cancellables" }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Cancellable sets must use the standard name `cancellables`.",
        why: """
            One predictable name (`var cancellables = Set<AnyCancellable>()`) makes \
            subscriptions greppable and lets developers move between classes without \
            re-learning naming. Multiple cancellable sets in one class is usually a sign \
            the class does too much.
            """,
        howToFix: "Rename the variable to `cancellables`.",
        badExample: """
            private var subscriptions = Set<AnyCancellable>()
            private var locationCancellables = Set<AnyCancellable>()
            """,
        goodExample: """
            private var cancellables = Set<AnyCancellable>()
            """
    )
}
