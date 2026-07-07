import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotDependsOnRepositories: QuickSpec {
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

    private static let message = LintRuleMessage(
        rule: "ViewModels must not depend on Repositories directly.",
        why: """
            ViewModels should only orchestrate Logic classes. Injecting a Repository into a \
            ViewModel skips the Logic layer, which is where business rules and error mapping \
            live, and couples the presentation layer to the data layer.
            """,
        howToFix: """
            Create (or reuse) a Logic class that wraps the Repository call and inject that \
            Logic class into the ViewModel instead.
            """,
        badExample: """
            public final class CountryListViewModel: ObservableObject {
                public init(repository: CountryListRepository) { ... }
            }
            """,
        goodExample: """
            public final class CountryListViewModel: ObservableObject {
                public init(logic: CountryListLogic) { ... }
            }
            """
    )
}
