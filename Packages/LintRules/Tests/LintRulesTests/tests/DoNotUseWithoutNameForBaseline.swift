//
//  DoNotUseWithoutNameForBaseline.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import XCTest

final class DoNotUseWithoutNameForBaseline: QuickSpec {
    override class func spec() {
        Given("A Harmonize lint rule file") {
            let testDir = URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent() // tests/
                .deletingLastPathComponent() // LintRulesTests/

            let ruleFiles = findSwiftFiles(in: testDir)
                .filter { $0.isInSubdirectory }

            Then("It does not use .withoutName(baseline) or .withoutName(allowed) to filter violations") {
                let violations = ruleFiles.filter { file in
                    guard let contents = try? String(contentsOf: file.url, encoding: .utf8) else {
                        return false
                    }
                    return contents.range(
                        of: #"\.withoutName\(\s*(Self\.)?(baseline|allowed)\s*\)"#,
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
        rule: "Lint rules must pass `baseline`/`allowed` to the assertion, not to `.withoutName(...)`.",
        why: """
            `.withoutName(baseline)` or `.withoutName(allowed)` silently drops elements
            before assertion, so entries that no longer violate the rule are never reported
            and the list grows stale. Passing `baseline:` to `assertTrue` / `assertFalse` /
            `assertEmpty` enables Harmonize's stale-baseline detection: when a baselined
            element starts passing, the rule fails with a "Stale baseline" message so the
            entry can be removed.
            """,
        howToFix: """
            Remove `.withoutName(baseline)` / `.withoutName(allowed)` from the items pipeline
            and pass the list as a parameter to the assertion. Use filenames with `.swift`
            for baseline entries. If the assertion runs against children of a container
            (e.g. `protocols.functions()`), assert on the container with `allSatisfy` inside
            the predicate so the baseline matches cleanly at the file level.
            """,
        badExample: """
            let logicClasses = HarmonizeTravelAdvisories.logicProduction
                .withoutName(baseline)

            logicClasses.assertTrue(message: message) { ... }

            private static let baseline = ["CountryListLogic"]
            """,
        goodExample: """
            let logicClasses = HarmonizeTravelAdvisories.logicProduction

            logicClasses.assertTrue(message: message, baseline: baseline) { ... }

            private static let baseline = ["CountryListLogic.swift"]
            """
    )

    // This rule's own badExample contains the forbidden pattern, so it baselines itself.
    private static let baseline: Set<String> = [
        "DoNotUseWithoutNameForBaseline.swift"
    ]
}
