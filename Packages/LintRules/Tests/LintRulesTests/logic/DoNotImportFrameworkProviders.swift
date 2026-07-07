//
//  DoNotImportFrameworkProviders.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics
import Nimble

final class DoNotImportFrameworkProviders: QuickSpec {
    override class func spec() {
        Given("A logic class in production code") {
            let logicClassSources = HarmonizeTravelAdvisories.logicPackage.sources()

            Then("It does not import FrameworkProviders") {
                logicClassSources.withImport("FrameworkProviders").assertEmpty(message: message)
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Do not import FrameworkProviders directly except in the outer layer.",
        why: """
            Interior layers must depend on abstractions, not concrete framework wrappers. \
            Importing FrameworkProviders couples Logic to CoreLocation-style frameworks and \
            makes tests require real framework behavior.
            """,
        howToFix: """
            Import FrameworkProviderProtocols (for the protocol) or \
            FrameworkProviderProtocolModels (for the model types) instead, and let DI \
            provide the concrete implementation.
            """,
        badExample: """
            import FrameworkProviders

            public final class GetNewLocationLogic {
                private let provider: LocationProvider
            }
            """,
        goodExample: """
            import FrameworkProviderProtocols

            public final class GetNewLocationLogic {
                private let provider: LocationProviding
            }
            """
    )
}
