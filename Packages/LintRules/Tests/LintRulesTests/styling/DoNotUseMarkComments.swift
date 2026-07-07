//
//  DoNotUseMarkComments.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotUseMarkComments: QuickSpec {
    override class func spec() {
        Given("Any source file in production or test code") {
            let sources = HarmonizeTravelAdvisories.productionAndTestCode.sources()

            Then("it does not contain MARK comments") {
                sources.assertFalse(message: message, baseline: baseline) {
                    $0.source.contains(Regex(#/\/\/ MARK/#))
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Do not use MARK comments (// MARK).",
        why: """
            MARK comments are a code smell indicating the file is doing too much and \
            violates the Single Responsibility Principle. Instead of hiding complexity \
            behind collapsible regions, split the file.
            """,
        howToFix: """
            Extract each MARK-delimited section into its own type or extension file — \
            e.g. move a "// MARK: - Networking" block into a dedicated Logic or \
            Repository class.
            """,
        badExample: """
            final class CountryListViewModel {
                // MARK: - State
                ...
                // MARK: - Location handling
                ...
            }
            """,
        goodExample: """
            final class CountryListViewModel { /* state only */ }
            final class GetCurrentLocationLogic { /* location handling */ }
            """
    )

    // EXISTING VIOLATIONS - DO NOT ADD TO THIS BASELINE
    private static let baseline = [
        "Localized+Generated.swift",
        "Gherkin+Extensions.swift",
        "Inject.swift",
        "OnPageLoadedModifier.swift",
    ]
}
