//
//  AllRulesMustUseLintRuleMessage.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import XCTest

final class AllRulesMustUseLintRuleMessage: QuickSpec {
    override class func spec() {
        Given("A Harmonize lint rule file") {
            let testDir = URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent() // tests/
                .deletingLastPathComponent() // LintRulesTests/

            let ruleFiles = findSwiftFiles(in: testDir)
                .filter { $0.isInSubdirectory }

            Then("It references LintRuleMessage") {
                let violations = ruleFiles.filter { file in
                    guard let contents = try? String(contentsOf: file.url, encoding: .utf8) else {
                        return true
                    }
                    return !contents.contains("LintRuleMessage")
                }

                // We use XCTAssertTrue instead of Harmonize assertions because this rule
                // scans raw file contents via FileManager, not AST nodes. Harmonize assertions
                // operate on `[SyntaxNodeProviding]` arrays from parsed source code, which
                // doesn't apply here since we're checking the LintRules test files themselves.
                XCTAssertTrue(
                    violations.isEmpty,
                    """
                    \(message.formatted)

                    Violating files:
                    \(violations.map(\.name).joined(separator: "\n"))
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
            let name = url.deletingPathExtension().lastPathComponent
            let parent = url.deletingLastPathComponent()
            let isInSubdirectory = parent != directory
            return RuleFile(name: name, url: url, isInSubdirectory: isInSubdirectory)
        }
    }

    private static let message = LintRuleMessage(
        rule: "All Harmonize lint rules must use LintRuleMessage for assertion messages.",
        why: """
            Structured messages ensure every rule explains WHY it exists, HOW TO FIX violations,
            and provides good/bad examples. This prevents AI agents from bypassing rules
            because they don't understand the architectural reasoning behind them.
            """,
        howToFix: """
            Replace raw String messages with a LintRuleMessage instance and use
            the assertTrue/assertFalse/assertEmpty overloads that accept a LintRuleMessage parameter.
            """,
        badExample: """
            private static let message = "Logic classes should expose callAsFunction."

            violations.assertEmpty(message: Self.message)
            """,
        goodExample: """
            private static let message = LintRuleMessage(
                rule: "Logic classes must expose callAsFunction().",
                why: "Logic classes follow SRP — one class, one use case.",
                howToFix: "Rename your public function to callAsFunction().",
                badExample: "class MyLogic { func execute() { ... } }",
                goodExample: "class MyLogic { func callAsFunction() { ... } }"
            )

            violations.assertEmpty(message: Self.message)
            """
    )
}
