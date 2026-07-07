import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotUseMockApisForSettingState: QuickSpec {
    nonisolated(unsafe)
    private static let settingStateInApiRegex = #/(\w+)?(?i:api)\.\w+\s=\s/#

    override class func spec() {
        Given("A test class, excluding test factories") {
            let testClasses = HarmonizeTravelAdvisories.testCode
                .classes()
                .withoutSuffix("Factory")

            Then("It does not set state in a mock API") {
                testClasses.assertFalse(message: message, baseline: baseline) { test in
                    test.description.contains(settingStateInApiRegex)
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Tests must use test factories to set state, not mock APIs directly.",
        why: """
            Setting state on a mock API couples each test to the API's internal shape. \
            Test factories centralize state setup, so when an API changes only the factory \
            needs updating — not every test.
            """,
        howToFix: """
            Move the state assignment into a test factory (a class suffixed with `Factory`) \
            and call the factory from the test.
            """,
        badExample: """
            final class CountryListViewModelTests: QuickSpec {
                override class func spec() {
                    beforeEach {
                        mockApi.countryListResult = .success(.mock)
                    }
                }
            }
            """,
        goodExample: """
            final class CountryListViewModelTests: QuickSpec {
                override class func spec() {
                    beforeEach {
                        CountryListTestFactory().withCountries([.mock]).build()
                    }
                }
            }
            """
    )

    private static let baseline: [String] = [
        "CountryListRepositoryTests",
        "CountryListErrorTests",
        "CountryDetailsRepositoryTests",
        "CountryDetailsViewModelTests",
        "CountryListViewModelTests",
        "CountryDetailsLogicTests",
        "CountryListLogicTests"
    ]
}
