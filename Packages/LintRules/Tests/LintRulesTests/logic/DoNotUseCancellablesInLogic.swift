//
//  DoNotUseCancellablesInLogic.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotUseCancellablesInLogic: QuickSpec {
    override class func spec() {
        Given("A Logic class in production") {
            let logicClasses = HarmonizeTravelAdvisories.logicProduction

            Then("It does not declare cancellables") {
                logicClasses
                    .variables()
                    .withNameContaining("cancellables")
                    .assertEmpty(message: message)
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Do not include cancellables in a Logic class.",
        why: """
            Logic classes should be stateless: they receive a request and return a \
            publisher. Holding subscriptions in a Logic class introduces hidden state and \
            lifecycle questions (who cancels, and when?) that belong to the ViewModel.
            """,
        howToFix: """
            Return the AnyPublisher from callAsFunction and let the caller (usually a \
            ViewModel) subscribe and store the cancellable, or use `assign(to:)` for \
            republishing into an @Published property.
            """,
        badExample: """
            public final class CountryListLogic {
                private var cancellables = Set<AnyCancellable>()

                public func callAsFunction() {
                    repository.reload().sink { ... }.store(in: &cancellables)
                }
            }
            """,
        goodExample: """
            public final class CountryListLogic {
                public func callAsFunction() -> AnyPublisher<Void, CountryListError> {
                    repository.reload().eraseToAnyPublisher()
                }
            }
            """
    )
}
