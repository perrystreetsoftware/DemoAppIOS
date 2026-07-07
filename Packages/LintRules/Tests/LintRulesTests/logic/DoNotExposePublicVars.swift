import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotExposePublicVars: QuickSpec {
    private static let allowedAttributes = ["Published", "CurrentValue"]

    override class func spec() {
        Given("A logic class in production code") {
            let logicClasses = HarmonizeTravelAdvisories.logicProduction

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

    private static let message = LintRuleMessage(
        rule: "Logic classes must not expose public vars other than @Published or CurrentValue streams.",
        why: """
            Logic classes should expose a single callAsFunction or a reactive stream \
            (@Published / CurrentValue). Arbitrary public mutable state on a Logic class \
            breaks unidirectional data flow and makes the class harder to test.
            """,
        howToFix: """
            Make the variable private, or expose it as a @Published stream if downstream \
            layers need to observe it.
            """,
        badExample: """
            public final class CountryListLogic {
                public var continents: [Continent] = []
            }
            """,
        goodExample: """
            public final class CountryListLogic {
                @Published public private(set) var continents: [Continent] = []
            }
            """
    )
}
