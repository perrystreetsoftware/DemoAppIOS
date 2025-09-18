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
    
    private static var pastTenseMessage: String {
        "Verbs in ViewModel functions that represent user actions should not be in past tense."
    }

    private static var clickMessage: String {
        "ViewModel function represents a user action and should use 'tap' instead of 'click'."
    }
}
