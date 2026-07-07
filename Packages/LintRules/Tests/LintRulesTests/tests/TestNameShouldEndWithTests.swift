//
//  TestNameShouldEndWithTests.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class TestNameShouldEndWithTests: QuickSpec {
    private static let testBaseClasses = ["QuickSpec", "XCTestCase"]

    override class func spec() {
        Given("A test class") {
            let testClasses = HarmonizeTravelAdvisories.classesTest
                .filter { klass in
                    klass.inheritanceTypesNames.contains { testBaseClasses.contains($0) }
                }

            Then("Its name ends with Tests") {
                testClasses.assertTrue(message: message) {
                    $0.name.hasSuffix("Tests")
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Test classes must end with the `Tests` suffix.",
        why: """
            A consistent suffix makes test classes discoverable (the run-tests.sh script \
            auto-detects a class's package by name), keeps them aligned with their \
            production counterpart (`CountryListViewModel` -> `CountryListViewModelTests`), \
            and lets tooling and lint scopes tell test classes apart from helpers.
            """,
        howToFix: """
            Rename the class (and its file) to `<ProductionClassName>Tests`.
            """,
        badExample: """
            final class CountryListViewModelSpec: QuickSpec { ... }
            """,
        goodExample: """
            final class CountryListViewModelTests: QuickSpec { ... }
            """
    )
}
