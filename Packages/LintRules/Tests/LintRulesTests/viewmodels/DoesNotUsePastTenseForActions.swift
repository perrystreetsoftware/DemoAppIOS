import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoesNotUsePastTenseForActions: QuickSpec {
    override class func spec() {
        Given("A ViewModel") {
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction

            When("There is a function for a user action") {
                let functions = viewModels.functions()
                    .withPrefix("on")
                    .withNameContaining("Tap")

                Then("It does not use past tense in its name") {
                    functions.assertFalse(message: pastTenseMessage) {
                        $0.name.hasSuffix("ed")
                    }
                }

                Then("It uses 'tap' instead of 'click' in its name") {
                    functions.assertFalse(message: clickMessage) {
                        $0.name.contains("click")
                    }
                }
            }
        }
    }

    private static let pastTenseMessage = LintRuleMessage(
        rule: "ViewModel user-action functions must not use past tense.",
        why: """
            A user action names the intent at the moment it happens (`onButtonTap`), not \
            an event that already completed. Present-tense names keep the ViewModel API \
            consistent and aligned with how SwiftUI forwards gestures.
            """,
        howToFix: "Rename the function to present tense, e.g. `onButtonTapped` becomes `onButtonTap`.",
        badExample: """
            public func onButtonTapped() { ... }
            """,
        goodExample: """
            public func onButtonTap() { ... }
            """
    )

    private static let clickMessage = LintRuleMessage(
        rule: "ViewModel user-action functions must use 'tap', not 'click'.",
        why: """
            iOS interactions are taps, not clicks. Consistent terminology keeps function \
            names searchable and aligned with platform conventions.
            """,
        howToFix: "Rename the function replacing 'click' with 'tap'.",
        badExample: """
            public func onButtonclickTap() { ... }
            """,
        goodExample: """
            public func onButtonTap() { ... }
            """
    )
}
