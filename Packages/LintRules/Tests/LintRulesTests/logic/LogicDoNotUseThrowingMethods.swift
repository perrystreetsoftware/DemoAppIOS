//
//  LogicDoNotUseThrowingMethods.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class LogicDoNotUseThrowingMethods: QuickSpec {
    override class func spec() {
        Given("A Logic class") {
            let logicFns = HarmonizeTravelAdvisories.logicProduction
                .functions()

            Then("It does not use throwing methods") {
                logicFns
                    .assertFalse(message: message) {
                        $0.node.signature.effectSpecifiers?.throwsClause?.throwsSpecifier != nil && $0.name == "callAsFunction"
                    }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Logic classes must not throw — use Combine AnyPublisher.",
        why: """
            Our data flow is reactive: failures travel through the publisher's typed \
            failure so ViewModels can handle them declaratively. A throwing callAsFunction \
            forces imperative do/catch handling and loses the typed error.
            """,
        howToFix: """
            Return an AnyPublisher with a typed failure instead of throwing, e.g. \
            `Fail(error:)` / `Just(...).setFailureType(to:)` for synchronous results.
            """,
        badExample: """
            public func callAsFunction() throws -> PSSLocation { ... }
            """,
        goodExample: """
            public func callAsFunction() -> AnyPublisher<PSSLocation, LocationLogicError> { ... }
            """
    )
}
