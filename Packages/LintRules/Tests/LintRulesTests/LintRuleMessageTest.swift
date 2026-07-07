//
//  LintRuleMessageTest.swift
//  LintRules
//
//  Infrastructure test for the LintRuleMessage API — not a lint rule.
//  Lives in the LintRulesTests root directory, which the meta-rules
//  (AllRulesMustUseLintRuleMessage / DoNotUseWithoutNameForBaseline)
//  exclude the same way they exclude the API infrastructure files.
//

import Foundation
import XCTest

final class LintRuleMessageTest: XCTestCase {
    private let message = LintRuleMessage(
        rule: "Test rule description.",
        why: "Test why reasoning.",
        howToFix: "Test how to fix steps.",
        badExample: "class TestBadExample {}",
        goodExample: "final class TestGoodExample {}"
    )

    func testFormattedContainsAllSections() {
        let formatted = message.formatted

        XCTAssertTrue(formatted.contains("RULE: Test rule description."))
        XCTAssertTrue(formatted.contains("WHY: Test why reasoning."))
        XCTAssertTrue(formatted.contains("HOW TO FIX: Test how to fix steps."))
        XCTAssertTrue(formatted.contains("❌ BAD:"))
        XCTAssertTrue(formatted.contains("class TestBadExample {}"))
        XCTAssertTrue(formatted.contains("✅ GOOD:"))
        XCTAssertTrue(formatted.contains("final class TestGoodExample {}"))
    }

    func testSectionsAppearInReadingOrder() {
        let formatted = message.formatted
        let sections = [
            "RULE:",
            "WHY:",
            "HOW TO FIX:",
            "❌ BAD:",
            "class TestBadExample {}",
            "✅ GOOD:",
            "final class TestGoodExample {}",
        ]

        let indices = sections.map { section -> String.Index in
            guard let range = formatted.range(of: section) else {
                XCTFail("Section '\(section)' not found in formatted output")
                return formatted.startIndex
            }
            return range.lowerBound
        }

        XCTAssertEqual(indices, indices.sorted(), "Sections must appear in reading order: \(sections)")
    }
}
