//
//  LogicDoNotUseThrowingMethods.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions

final class LogicDoNotUseThrowingMethods: QuickSpec {
    override class func spec() {
        Given("A Logic class") {
            let logicFns = HarmonizeTravelAdvisories.logicProduction
                .withoutName(Self.baseline)
                .functions()

            Then("It does not use throwing methods") {
                (logicFns)
                    .assertFalse(message: Self.message) {
                        $0.node.signature.effectSpecifiers?.throwsClause?.throwsSpecifier != nil && $0.name == "callAsFunction"
                }
            }
        }
    }

    private static let message = "Logic classes should not throw - use Combine AnyPublisher"
    private static let baseline: [String] = [
    ]
}

