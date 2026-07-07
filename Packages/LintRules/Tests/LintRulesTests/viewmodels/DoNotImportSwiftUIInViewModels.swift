//
//  DoNotImportSwiftUIInViewModels.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotImportSwiftUIInViewModels: QuickSpec {
    override class func spec() {
        Given("A ViewModel source file in production") {
            let viewModelFiles = HarmonizeTravelAdvisories.viewModelsPackage
                .sources()

            Then("It does not import SwiftUI") {
                viewModelFiles.assertFalse(message: message, baseline: baseline) {
                    $0.imports().contains { $0.name == "SwiftUI" }
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Do not import SwiftUI in ViewModels.",
        why: """
            ViewModels should not contain UI concepts like Color, Image, or View. Keeping \
            SwiftUI out of ViewModels keeps them platform-agnostic and unit-testable \
            without a UI runtime.
            """,
        howToFix: """
            Model the concept as data (an enum or struct in the UiState) and map it to \
            SwiftUI types in an extension in the Feature package.
            """,
        badExample: """
            import SwiftUI

            public final class CountryListViewModel: ObservableObject {
                @Published public var statusColor: Color = .green
            }
            """,
        goodExample: """
            public final class CountryListViewModel: ObservableObject {
                @Published public var state: CountryListUiState = CountryListUiState()
            }

            // In the Feature package:
            extension ServerStatus { var color: Color { ... } }
            """
    )

    private static let baseline = ["AboutViewModel.swift"]
}
