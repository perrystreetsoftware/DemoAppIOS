import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class EndsWithIngOrAble: QuickSpec {
    private static let allowed = ["DomainApiError", "LocationProvidingDelegate"]

    override class func spec() {
        Given("A protocol") {
            let protocols = Harmonize.productionCode().protocols()
                .withoutName(allowed)

            Then("It ends with ing or able") {
                protocols.assertTrue(message: "Protocols must end with ing or able") {
                    $0.name.hasSuffix("ing") || $0.name.hasSuffix("able")
                }
            }
        }
    }
}
