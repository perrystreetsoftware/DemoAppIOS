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
                logicClasses.functions().assertFalse(message: Self.repoErrorMessage) {
                    $0.returnClause?.typeAnnotation?.name.contains("RepositoryError>") == true
                }
            }
        }
    }

    private static let repoErrorMessage: String = """
        Logic classes should return specialized error types; otherwise dependent layers (such
        as the ViewModel layer) may have to `import Repositories` to obtain the error type. 
    
        Use a typealias if no new scenarios are added; for example:
    
        typealias LocationLogicError = LocationRepositoryError
    """
    
    private static let message: String = "Use typed Swift errors instead of generic `Error` type. Typed errors can be more easily converted by the UI layer into `dialogState` values. Typed errors are a capability of Swift not present in RxJava that we take advantage of."
}
