//
//  ViewLayerDoesNotUseIfStatements.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/17/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics
import SwiftSyntax
import Nimble

final class ViewLayerDoesNotUseIfStatements: QuickSpec {
    override class func spec() {
        Given("All if statements in the screens package") {
            let views = HarmonizeTravelAdvisories.presentationFeaturePackage.views
            let screenFunctions = views.functions()
            let screenGetters = views.variables().filter { $0.hasGetterBlock() }

            Then("It has #available") {
                screenFunctions.filter { !ifsOnlyCheckAvailable($0) }.assertEmpty(message: message)
                screenGetters.filter {
                    guard let getter = $0.getter else { return false }
                    return !ifsOnlyCheckAvailable(getter)
                }
                .assertEmpty(message: message)
            }
        }
    }

    private class func ifsOnlyCheckAvailable(_ body: BodyProviding) -> Bool {
        body.ifs().allSatisfy {
            $0.conditions.description.contains("#available")
        } && body.closures().allSatisfy { klosure in
            ifsOnlyCheckAvailable(klosure)
        }
    }

    private static let message = LintRuleMessage(
        rule: "If statements (other than #available checks) are not allowed in the View layer.",
        why: """
            Branching in our View layer means untested logic. When we cannot have branching \
            in the View layer, it forces us to think how to make that logic testable and how \
            to make it part of the state of the ViewModel. If you are seeing this error, \
            consider how you might put this component into the design system.
            """,
        howToFix: """
            Move the branching decision into the ViewModel state (e.g. an enum or boolean on \
            the UiState) and render it via a state extension that maps state to a view, or \
            extract the branching component into a reusable UI component.
            """,
        badExample: """
            var body: some View {
                if viewModel.state.isLoading {
                    ProgressView()
                } else {
                    CountryListView(continents: viewModel.state.continents)
                }
            }
            """,
        goodExample: """
            var body: some View {
                viewModel.state.contentView()
            }

            // In a UiState extension:
            extension CountryListUiState {
                @ViewBuilder func contentView() -> some View { ... }
            }
            """
    )
}
