//
//  LogicClassShouldUseTypedErrors.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class LogicClassShouldUseTypedErrors: QuickSpec {
    override class func spec() {
        Given("A logic class") {
            let logicClasses = HarmonizeTravelAdvisories.logicProduction

            Then("It uses typed Swift errors") {
                logicClasses.functions().assertFalse(message: message) {
                    $0.returnClause?.typeAnnotation?.name.contains(" Error>") == true
                }
            }

            Then("It wraps or typealiases RepositoryError classes") {
                logicClasses.functions().assertFalse(message: repoErrorMessage) {
                    $0.returnClause?.typeAnnotation?.name.contains("RepositoryError>") == true
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Logic classes must use typed Swift errors instead of the generic `Error` type.",
        why: """
            Typed errors can be more easily converted by the UI layer into `dialogState` \
            values. Typed errors are a capability of Swift not present in RxJava that we \
            take advantage of.
            """,
        howToFix: """
            Declare a specific error enum for the failure type of the returned publisher \
            instead of the generic `Error`.
            """,
        badExample: """
            public func callAsFunction() -> AnyPublisher<Void, Error> { ... }
            """,
        goodExample: """
            public func callAsFunction() -> AnyPublisher<Void, CountryListError> { ... }
            """
    )

    private static let repoErrorMessage = LintRuleMessage(
        rule: "Logic classes must wrap or typealias RepositoryError types.",
        why: """
            Logic classes should return specialized error types; otherwise dependent layers \
            (such as the ViewModel layer) may have to `import Repositories` to obtain the \
            error type.
            """,
        howToFix: """
            Use a typealias if no new scenarios are added; for example:

            typealias LocationLogicError = LocationRepositoryError
            """,
        badExample: """
            public func callAsFunction() -> AnyPublisher<Void, LocationRepositoryError> { ... }
            """,
        goodExample: """
            public typealias LocationLogicError = LocationRepositoryError

            public func callAsFunction() -> AnyPublisher<Void, LocationLogicError> { ... }
            """
    )
}
