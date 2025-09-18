import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotDependsOnRepositories: QuickSpec {
    private static let message = "ViewModels should not depend on Repositories directly. They should use Logic classes instead."
    
    override class func spec() {
        Given("A ViewModel") {
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction

            Then("It does not depend on repositories") {
                viewModels.initializers().parameters()
                    .withType { $0.name.hasSuffix("Repository") }
                    .assertEmpty(message: message)
            }
        }
    }
}
