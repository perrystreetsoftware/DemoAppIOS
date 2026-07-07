//
//  AssertionsTest.swift
//  LintRules
//
//  Infrastructure test for the baseline/stale-baseline assertion API — not a
//  lint rule. Lives in the LintRulesTests root directory, which the meta-rules
//  (AllRulesMustUseLintRuleMessage / DoNotUseWithoutNameForBaseline) exclude
//  the same way they exclude the API infrastructure files.
//
//  Runs against fixture code in Packages/LintRules/fixtures/, which is parsed
//  explicitly and is neither compiled into any target nor scanned by real
//  lint rules.
//

import Foundation
import Harmonize
import HarmonizeSemantics
import XCTest

final class AssertionsTest: XCTestCase {
    // The "rule" under test: classes must be final.
    // ViolatingFixture and AnotherViolatingFixture violate it; CleanFixture passes.
    private static let fixtureURL = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent() // LintRulesTests/
        .deletingLastPathComponent() // Tests/
        .deletingLastPathComponent() // LintRules/
        .appendingPathComponent("fixtures/HarmonizeFixtures.swift")

    private var fixtureClasses: [Class] {
        guard let source = SwiftSourceCode(url: Self.fixtureURL) else {
            XCTFail("Unable to parse fixture file at \(Self.fixtureURL.path)")
            return []
        }
        return source.classes(includeNested: false)
    }

    private let message = LintRuleMessage(
        rule: "Fixture classes must be final.",
        why: "Testing the baseline assertion API.",
        howToFix: "Add the final modifier.",
        badExample: "public class ViolatingFixture {}",
        goodExample: "public final class CleanFixture {}"
    )

    func testFixtureParses() {
        XCTAssertEqual(
            fixtureClasses.map(\.name),
            ["ViolatingFixture", "AnotherViolatingFixture", "CleanFixture"]
        )
    }

    // MARK: - a. Unbaselined violations fail with the formatted message and the violator's name

    func testUnbaselinedViolationFailsWithFormattedMessageAndName() {
        let failures = collectExpectedFailures {
            fixtureClasses.assertTrue(message: message) { $0.hasModifier(.final) }
        }

        XCTAssertFalse(failures.isEmpty, "Expected the assertion to fail for unbaselined violations")

        let combined = failures.joined(separator: "\n")
        XCTAssertTrue(combined.contains("RULE: Fixture classes must be final."))
        XCTAssertTrue(combined.contains("WHY: Testing the baseline assertion API."))
        XCTAssertTrue(combined.contains("HOW TO FIX: Add the final modifier."))
        XCTAssertTrue(combined.contains("❌ BAD:"))
        XCTAssertTrue(combined.contains("✅ GOOD:"))
        XCTAssertTrue(combined.contains("ViolatingFixture"), "Failure must name the violating declaration")
        XCTAssertTrue(combined.contains("AnotherViolatingFixture"), "Failure must name every violating declaration")
    }

    // MARK: - b. With all violations baselined, every assertion flavor passes

    func testAssertTruePassesWhenAllViolationsAreBaselined() {
        fixtureClasses.assertTrue(
            message: message,
            baseline: ["ViolatingFixture", "AnotherViolatingFixture"]
        ) { $0.hasModifier(.final) }
    }

    func testAssertFalsePassesWhenAllViolationsAreBaselined() {
        fixtureClasses.assertFalse(
            message: message,
            baseline: ["ViolatingFixture", "AnotherViolatingFixture"]
        ) { !$0.hasModifier(.final) }
    }

    func testAssertEmptyPassesWhenAllViolationsAreBaselined() {
        fixtureClasses
            .filter { !$0.hasModifier(.final) }
            .assertEmpty(
                message: message,
                baseline: ["ViolatingFixture", "AnotherViolatingFixture"]
            )
    }

    // MARK: - c. A baseline entry that no longer violates fails as stale

    func testBaselineEntryThatNoLongerViolatesFailsAsStale() {
        let failures = collectExpectedFailures {
            fixtureClasses.assertTrue(
                message: message,
                baseline: ["ViolatingFixture", "AnotherViolatingFixture", "CleanFixture"]
            ) { $0.hasModifier(.final) }
        }

        XCTAssertFalse(failures.isEmpty, "Expected a stale-baseline failure for CleanFixture")

        let combined = failures.joined(separator: "\n")
        XCTAssertTrue(combined.contains("Stale baseline"), "Failure must be reported as a stale baseline")
        XCTAssertTrue(combined.contains("CleanFixture"), "Stale-baseline failure must name the stale entry")
        XCTAssertFalse(combined.contains("AnotherViolatingFixture"), "Entries that still violate must not be reported")
    }

    // MARK: - d. A baseline entry that no longer exists fails as stale

    func testBaselineEntryThatNoLongerExistsFailsAsStale() {
        let failures = collectExpectedFailures {
            fixtureClasses.assertTrue(
                message: message,
                baseline: ["ViolatingFixture", "AnotherViolatingFixture", "NonExistentFixture"]
            ) { $0.hasModifier(.final) }
        }

        XCTAssertFalse(failures.isEmpty, "Expected a stale-baseline failure for NonExistentFixture")

        let combined = failures.joined(separator: "\n")
        XCTAssertTrue(combined.contains("Stale baseline"), "Failure must be reported as a stale baseline")
        XCTAssertTrue(combined.contains("NonExistentFixture"), "Stale-baseline failure must name the missing entry")
    }

    // MARK: - Helpers

    /// Runs `body` expecting XCTest failures, swallows them, and returns their descriptions.
    private func collectExpectedFailures(_ body: () -> Void) -> [String] {
        var descriptions: [String] = []

        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            descriptions.append(issue.compactDescription)
            return true
        }

        XCTExpectFailure("The assertion under test is expected to fail", options: options, failingBlock: body)

        return descriptions
    }
}
