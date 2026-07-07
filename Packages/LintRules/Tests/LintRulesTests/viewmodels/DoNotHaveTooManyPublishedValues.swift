//
//  DoNotHaveTooManyPublishedValues.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotHaveTooManyPublishedValues: QuickSpec {
    override class func spec() {
        Given("A ViewModel class in production code") {
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction

            Then("It does not define more than 3 @Published values") {
                viewModels.assertTrue(message: message, baseline: baseline) { viewModel in
                    viewModel.variables
                        .filter { $0.hasAnyAttribute(named: ["Published"]) }
                        .count <= 3
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Do not define more than 3 @Published values on a ViewModel.",
        why: """
            A ViewModel should expose one @Published state plus at most an error and a \
            navigation value. More published values mean views re-render on unrelated \
            changes and the ViewModel is accumulating multiple responsibilities.
            """,
        howToFix: """
            Fold related published values into the UiState struct, or break the class \
            into smaller ViewModels.
            """,
        badExample: """
            public final class CountryListViewModel: ObservableObject {
                @Published public var state: CountryListUiState = CountryListUiState()
                @Published public var navigationDestination: Country?
                @Published public var error: CountryListError? = nil
                @Published public var location: PSSLocation? = nil
            }
            """,
        goodExample: """
            public final class CountryListViewModel: ObservableObject {
                // location folded into CountryListUiState
                @Published public var state: CountryListUiState = CountryListUiState()
                @Published public var navigationDestination: Country?
                @Published public var error: CountryListError? = nil
            }
            """
    )

    // EXISTING VIOLATIONS - DO NOT ADD TO THIS BASELINE
    private static let baseline = ["CountryListViewModel.swift"]
}
