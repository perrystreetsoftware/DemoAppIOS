//
//  DoNotImportFrameworkProviders.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics
import Nimble

final class DoNotImportFrameworkProviders: QuickSpec {
    override class func spec() {
        Given("A logic class in production code") {
            let logicClassSources = HarmonizeTravelAdvisories.logicPackage.sources()

            Then("It does not expose public vars") {
                logicClassSources.withImport("FrameworkProviders").assertEmpty(message: Self.Message)
            }
        }
    }

    static let Message: String = """
        Do not directy import FrameworkProviders except in the outer layer;
        
        Interior layers should only be using FrameworkProviderProtocols and 
        FrameworkProviderProtocolModels
    """
}
