//
//  DoNotImportFrameworkProviderProtocols.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoNotImportFrameworkProviderProtocols: QuickSpec {
    override class func spec() {
        Given("A ViewModel") {
            let viewModels = HarmonizeTravelAdvisories
                .viewModelsPackage
                .sources()

            Then("It does not depend on FrameworkProviderProtocols") {
                viewModels
                    .withImport("FrameworkProviderProtocols")
                    .assertEmpty(message: message)
            }
        }
    }

    private static let message = """
        ViewModels should not import FrameworkProviderProtocols; those should not be imported
        by any layer besides Logic and Repositories.
    
        You may import FrameworkProviderProtocolModels
    """
}
