//
//  LintRuleMessage.swift
//  LintRules
//

import Foundation
import Harmonize
import HarmonizeSemantics

struct LintRuleMessage {
    let rule: String
    let why: String
    let howToFix: String
    let badExample: String
    let goodExample: String

    var formatted: String {
        """
        RULE: \(rule)

        WHY: \(why)

        HOW TO FIX: \(howToFix)

        ❌ BAD:
        \(badExample)

        ✅ GOOD:
        \(goodExample)
        """
    }
}

extension Array where Element == SwiftSourceCode {
    func assertTrue(
        message: LintRuleMessage,
        strict: Bool = false,
        baseline: [String] = [],
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        condition: (Element) -> Bool
    ) {
        assertTrue(
            message: message.formatted,
            strict: strict,
            baseline: baseline,
            fileID: fileID,
            file: file,
            line: line,
            column: column,
            condition: condition
        )
    }

    func assertFalse(
        message: LintRuleMessage,
        strict: Bool = false,
        baseline: [String] = [],
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        condition: (Element) -> Bool
    ) {
        assertFalse(
            message: message.formatted,
            strict: strict,
            baseline: baseline,
            fileID: fileID,
            file: file,
            line: line,
            column: column,
            condition: condition
        )
    }

    func assertEmpty(
        message: LintRuleMessage,
        baseline: [String] = [],
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) {
        assertEmpty(
            message: message.formatted,
            baseline: baseline,
            fileID: fileID,
            file: file,
            line: line,
            column: column
        )
    }
}

extension Array where Element: SyntaxNodeProviding {
    func assertTrue(
        message: LintRuleMessage,
        strict: Bool = false,
        baseline: [String] = [],
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        condition: (Element) -> Bool
    ) {
        assertTrue(
            message: message.formatted,
            strict: strict,
            baseline: baseline,
            fileID: fileID,
            file: file,
            line: line,
            column: column,
            condition: condition
        )
    }

    func assertFalse(
        message: LintRuleMessage,
        strict: Bool = false,
        baseline: [String] = [],
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column,
        condition: (Element) -> Bool
    ) {
        assertFalse(
            message: message.formatted,
            strict: strict,
            baseline: baseline,
            fileID: fileID,
            file: file,
            line: line,
            column: column,
            condition: condition
        )
    }

    func assertEmpty(
        message: LintRuleMessage,
        baseline: [String] = [],
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        line: UInt = #line,
        column: UInt = #column
    ) {
        assertEmpty(
            message: message.formatted,
            baseline: baseline,
            fileID: fileID,
            file: file,
            line: line,
            column: column
        )
    }
}
