//
//  LogicClassShouldOnlyExposeOneFunction.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class LogicClassShouldOnlyExposeOneFunction: QuickSpec {
    override class func spec() {
        Given("A logic class in production code") {
            let logicClasses = HarmonizeTravelAdvisories.logicProduction

            Then("It exposes callAsFunction as the only public function") {
                logicClasses.assertTrue(message: message, baseline: baseline) {
                    let functions = $0.functions.withoutModifier(.private)
                    return functions.count == 1 && functions[0].name == "callAsFunction"
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Logic classes must expose a single `callAsFunction()` as their public function.",
        why: """
            Logic classes follow the Single Responsibility Principle — one class, one use \
            case. The `callAsFunction()` convention makes the class callable like a \
            function, clearly communicating that it represents a single operation. Without \
            this convention, consumers don't know which function to call.
            """,
        howToFix: """
            Rename your public function to `callAsFunction()`. If the class needs \
            parameters, accept them as callAsFunction parameters. If the class exposes \
            several operations, split it into one Logic class per operation.
            """,
        badExample: """
            @Factory
            public final class CountryDetailsLogic {
                private let repository: CountryDetailsRepository

                public func getDetails(country: Country) -> AnyPublisher<CountryDetails, CountryDetailsError> {
                    repository.getDetails(country: country)
                }
            }
            """,
        goodExample: """
            @Factory
            public final class GetCountryDetailsLogic {
                private let repository: CountryDetailsRepository

                public func callAsFunction(country: Country) -> AnyPublisher<CountryDetails, CountryDetailsError> {
                    repository.getDetails(country: country)
                }
            }
            """
    )

    // EXISTING VIOLATIONS - DO NOT ADD TO THIS BASELINE
    private static let baseline = [
        "CountryListLogic.swift",
        "CountryDetailsLogic.swift",
        "ServerStatusLogic.swift",
    ]
}
