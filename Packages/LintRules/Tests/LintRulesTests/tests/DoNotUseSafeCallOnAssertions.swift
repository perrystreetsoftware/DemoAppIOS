//
//  DoNotUseSafeCallOnAssertions.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import XCTest

final class DoNotUseSafeCallOnAssertions: QuickSpec {
    override class func spec() {
        Given("A Harmonize lint rule file") {
            let testDir = URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent() // tests/
                .deletingLastPathComponent() // LintRulesTests/

            let ruleFiles = findSwiftFiles(in: testDir)
                .filter { $0.isInSubdirectory }

            Then("It does not call assertions through optional chaining") {
                let violations = ruleFiles.filter { file in
                    guard let contents = try? String(contentsOf: file.url, encoding: .utf8) else {
                        return false
                    }
                    return contents.range(
                        of: #"\?\s*\.\s*assert(True|False|Empty|NotEmpty|Count)"#,
                        options: .regularExpression
                    ) != nil
                }

                let violationNames = Set(violations.map(\.name))
                let nonBaselinedViolations = violations.filter { !baseline.contains($0.name) }
                let staleEntries = baseline.filter { !violationNames.contains($0) }

                // We use XCTAssertTrue instead of Harmonize assertions because this rule
                // scans raw file contents via FileManager, not AST nodes.
                XCTAssertTrue(
                    nonBaselinedViolations.isEmpty,
                    """
                    \(message.formatted)

                    Violating files:
                    \(nonBaselinedViolations.map(\.name).joined(separator: "\n"))
                    """
                )

                XCTAssertTrue(
                    staleEntries.isEmpty,
                    """
                    Stale baseline entries (no longer violating — remove from baseline):
                    \(staleEntries.sorted().joined(separator: "\n"))
                    """
                )
            }
        }
    }

    private struct RuleFile {
        let name: String
        let url: URL
        let isInSubdirectory: Bool
    }

    private static func findSwiftFiles(in directory: URL) -> [RuleFile] {
        guard
            let enumerator = FileManager.default.enumerator(
                at: directory,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )
        else {
            return []
        }

        return enumerator.compactMap { item -> RuleFile? in
            guard let url = item as? URL,
                url.pathExtension == "swift"
            else {
                return nil
            }
            let name = url.lastPathComponent
            let parent = url.deletingLastPathComponent()
            let isInSubdirectory = parent != directory
            return RuleFile(name: name, url: url, isInSubdirectory: isInSubdirectory)
        }
    }

    private static let message = LintRuleMessage(
        rule: "Lint rules must not call assertions through optional chaining.",
        why: """
            An optional-chained assertion (`maybeElements?.assertTrue { ... }`) silently
            does nothing when the receiver is nil — the rule reports green while checking
            nothing at all. Assertions must run unconditionally so a broken query is loud,
            not invisible.
            """,
        howToFix: """
            Make the receiver non-optional: resolve the query to a concrete array before
            asserting, and fail explicitly (e.g. XCTFail) if a required value is missing.
            """,
        badExample: """
            let viewModels = maybeScope?.classes()
            viewModels?.assertTrue(message: message) { ... }
            """,
        goodExample: """
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction
            viewModels.assertTrue(message: message) { ... }
            """
    )

    // This rule's own badExample contains the forbidden pattern, so it baselines itself.
    private static let baseline: Set<String> = [
        "DoNotUseSafeCallOnAssertions.swift"
    ]
}
