//
//  ClassesMustBeFinal.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class ClassesMustBeFinal: QuickSpec {
    override class func spec() {
        Given("A class in production code") {
            let allClasses = HarmonizeTravelAdvisories.classesProduction
                .withoutNameContaining("Mock")

            Then("It must be final") {
                allClasses.assertTrue(message: message, baseline: baseline) { klass in
                    klass.hasModifier(.final) || klass.hasModifier(.open)
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Classes must be final unless they are explicitly designed for subclassing.",
        why: """
            `final` enables whole-module optimization (static dispatch instead of dynamic \
            dispatch) and documents that the class is not an inheritance point. Our DI \
            code generation for @Single and @Factory also assumes final classes.
            """,
        howToFix: """
            Add the `final` modifier to the class. If the class is genuinely meant to be \
            subclassed, mark it `open` instead.
            """,
        badExample: """
            public class AppSchedulerProvider: AppSchedulerProviding { ... }
            """,
        goodExample: """
            public final class AppSchedulerProvider: AppSchedulerProviding { ... }
            """
    )

    // EXISTING VIOLATIONS - DO NOT ADD TO THIS BASELINE
    private static let baseline = ["AppSchedulerProvider.swift"]
}
