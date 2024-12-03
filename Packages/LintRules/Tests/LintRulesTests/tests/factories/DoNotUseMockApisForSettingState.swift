import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotUseMockApisForSettingState: QuickSpec {
    private static let message = "Use test factories to set state, do not use mock APIs directly"
    
    
    private static let baseline: [String] = [
        "CountryListRepositoryTests",
        "CountryListErrorTests",
        "CountryDetailsRepositoryTests",
        "CountryDetailsViewModelTests",
        "CountryListViewModelTests",
        "CountryDetailsLogicTests",
        "CountryListLogicTests"
    ]
    
    nonisolated(unsafe)
    private static let settingStateInApiRegex = #/(\w+)?(?i:api)\.\w+\s=\s/#

    override class func spec() {
        Given("A test class, excluding test factories") {
            let testClasses = Harmonize.testCode()
                .classes()
                .withoutSuffix("Factory")
                .withoutName(baseline)

            Then("It does not set state in a mock API") {
                testClasses.assertFalse(message: message) { test in
                    test.description.contains(settingStateInApiRegex)
                }
            }
        }
    }
}
