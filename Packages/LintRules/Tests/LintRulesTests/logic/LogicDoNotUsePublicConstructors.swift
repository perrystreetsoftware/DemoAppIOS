//
//  LogicDoNotUsePublicConstructors.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions

final class LogicDoNotUsePublicConstructors: QuickSpec {
    override class func spec() {
        Given("A Logic class") {
            let logicConstructors = HarmonizeTravelAdvisories.logicProduction
                .withoutName(Self.baseline)
                .initializers()

            Then("It does not use public constructors") {
                (logicConstructors)
                    .assertFalse(message: "Logic classes should not use public constructors if they use DI") {
                        $0.hasModifier(.public)
                }
            }
        }
    }

    private static let baseline: [String] = []
}

