//
//  ShouldCaptureSelfWeaklyOnViewModels.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class ShouldCaptureSelfWeaklyOnViewModels: QuickSpec {
    override class func spec() {
        Given("A ViewModel class in production code") {
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction

            When("you capture self on a closure") {
                Then("It should be captured weakly") {
                    viewModels.assertTrue(message: message, baseline: baseline) { viewModel in
                        viewModel.functions
                            .filter(\.hasAnyClosureWithSelfReference)
                            .allSatisfy { function in
                                function.closures()
                                    .filter(\.hasSelfReference)
                                    .allSatisfy { $0.isCapturingWeak(valueOf: "self") }
                            }
                    }
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "ViewModels must capture self weakly in closures.",
        why: """
            ViewModels hold long-lived Combine subscriptions. A strong `self` capture \
            inside a sink or handleEvents closure creates a retain cycle between the \
            ViewModel and its cancellables, leaking the ViewModel when the view goes away.
            """,
        howToFix: """
            Add `[weak self]` to the closure's capture list and guard-unwrap self at \
            the top of the closure.
            """,
        badExample: """
            logic().sink { location in
                self.location = location
            }.store(in: &cancellables)
            """,
        goodExample: """
            logic().sink { [weak self] location in
                guard let self else { return }

                self.location = location
            }.store(in: &cancellables)
            """
    )

    // EXISTING VIOLATIONS - DO NOT ADD TO THIS BASELINE
    private static let baseline = ["CountryListViewModel.swift"]
}
