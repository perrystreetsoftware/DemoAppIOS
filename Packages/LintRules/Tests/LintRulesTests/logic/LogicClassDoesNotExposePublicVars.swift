import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class LogicClassDoesNotExposePublicVars: QuickSpec {
    private static let allowedAttributes = ["Published", "CurrentValue"]
    private static let message = "Logic classes should only expose a single callAsFunction or @Published var"
    
    override class func spec() {
        Given("A logic class in production code") {
            let logicClasses = Harmonize.on("Logic").classes().withSuffix("Logic")

            Then("It does not expose public vars") {
                logicClasses.assertTrue(message: message) {
                    let variables = $0.variables.withModifier(.public).filter { variable in
                        return !variable.hasAnyAttribute(named: allowedAttributes) &&
                            !variable.hasModifier(.static)
                    }

                    return variables.count == 0
                }
            }
        }
    }
}
