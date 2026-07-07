//
//  DoNotUseFocusedTests.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotUseFocusedTests: QuickSpec {
    nonisolated(unsafe)
    private static let focusedTestRegex = #/\bf(Given|Then|When|And|it|context|describe)\("/#

    override class func spec() {
        Given("A test class") {
            let testClasses = HarmonizeTravelAdvisories.testCode
                .classes()

            Then("It does not use focused tests") {
                testClasses
                    .assertFalse(message: message) { test in
                        test.description.contains(focusedTestRegex)
                    }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Do not use focused tests (fGiven, fWhen, fAnd, fThen, fit, fcontext, fdescribe).",
        why: """
            A single focused example makes Quick silently SKIP every other test in the \
            same test bundle. A committed fThen in CountryListViewModelTests kept 4 of \
            its 5 tests from ever running until it was noticed. Focus is a local \
            debugging tool only — it must never be committed.
            """,
        howToFix: """
            Remove the `f` prefix before committing (fThen -> Then, fcontext -> context, \
            and so on).
            """,
        badExample: """
            fThen("We get multiple errors") {
                expect(recorder.allElementsDescription) == ["updating", "error"]
            }
            """,
        goodExample: """
            Then("We get multiple errors") {
                expect(recorder.allElementsDescription) == ["updating", "error"]
            }
            """
    )
}
