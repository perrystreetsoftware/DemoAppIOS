//
//  DoNotUseRepositoriesInRepositories.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotUseRepositoriesInRepositories: QuickSpec {
    override class func spec() {
        Given("A repository class") {
            let repositories = HarmonizeTravelAdvisories.repositoriesProduction

            When("It has initializers") {
                let initializers = repositories.initializers()

                Then("It should not have parameters that are other repositories") {
                    initializers.assertFalse(message: message) { initializer in
                        initializer.parameters.contains { parameter in
                            parameter.typeAnnotation?.name.hasSuffix("Repository") == true
                        }
                    }
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Repositories must not depend on other repositories.",
        why: """
            Repository-to-repository dependencies create hidden data-flow chains and make \
            caching behavior unpredictable. Composition of data sources is a business \
            concern that belongs in the Logic layer.
            """,
        howToFix: """
            Connect the two repositories through a Logic class that injects both and \
            combines their outputs.
            """,
        badExample: """
            @Single
            public final class CountryDetailsRepository {
                init(countryListRepository: CountryListRepository) { ... }
            }
            """,
        goodExample: """
            @Factory
            public final class GetCountryDetailsLogic {
                private let countryListRepository: CountryListRepository
                private let countryDetailsRepository: CountryDetailsRepository
            }
            """
    )
}
