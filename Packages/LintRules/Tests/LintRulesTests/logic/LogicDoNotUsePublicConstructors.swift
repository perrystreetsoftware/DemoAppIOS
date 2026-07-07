//
//  LogicDoNotUsePublicConstructors.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class LogicDoNotUsePublicConstructors: QuickSpec {
    override class func spec() {
        Given("A Logic class") {
            let logicConstructors = HarmonizeTravelAdvisories.logicProduction
                .initializers()

            Then("It does not use public constructors") {
                logicConstructors
                    .assertFalse(message: message) {
                        $0.hasModifier(.public)
                    }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Logic classes must not declare public constructors.",
        why: """
            Logic classes are created through dependency injection (the @Factory macro \
            generates the resolution). A public constructor invites callers to build Logic \
            classes manually, bypassing DI and its lifecycle guarantees.
            """,
        howToFix: """
            Remove the `public` modifier from the initializer (or remove the explicit \
            initializer entirely) and resolve the class through the DI container.
            """,
        badExample: """
            @Factory
            public final class CountryListLogic {
                public init(countryListRepository: CountryListRepository) { ... }
            }
            """,
        goodExample: """
            @Factory
            public final class CountryListLogic {
                init(countryListRepository: CountryListRepository) { ... }
            }
            """
    )
}
