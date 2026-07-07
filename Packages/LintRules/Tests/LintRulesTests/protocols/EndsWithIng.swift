import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class EndsWithIngOrAble: QuickSpec {
    override class func spec() {
        Given("A protocol") {
            let protocols = HarmonizeTravelAdvisories.productionCode.protocols()

            Then("It ends with ing or able") {
                protocols.assertTrue(message: message, baseline: allowed) {
                    $0.name.hasSuffix("ing") || $0.name.hasSuffix("able")
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Protocols must end with `ing` or `able`.",
        why: """
            Protocols describe capabilities, not concrete things. Naming them after the \
            capability (`LocationProviding`, `FloatingAlertProviding`) distinguishes them \
            from the classes that implement them and keeps DI registrations readable.
            """,
        howToFix: """
            Rename the protocol to describe the capability it provides, ending in `ing` or \
            `able` (e.g. `LocationProvider` protocol becomes `LocationProviding`).
            """,
        badExample: """
            public protocol LocationManager {
                func requestLocation()
            }
            """,
        goodExample: """
            public protocol LocationProviding {
                func requestLocation()
            }
            """
    )

    // Intentionally permitted exceptions.
    private static let allowed = ["DomainApiError", "LocationProvidingDelegate"]
}
