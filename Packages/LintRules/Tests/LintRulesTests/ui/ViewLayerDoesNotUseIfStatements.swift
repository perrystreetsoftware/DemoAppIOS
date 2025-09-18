//
//  ViewLayerDoesNotUseIfStatements.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/17/25.
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics
import SwiftSyntax
import Quick
import Nimble

final class ViewLayerDoesNotUseIfStatements: QuickSpec {
    static let message = """
        If statements are not allowed in the View layer. Branching in our View layer means untested logic.
        When we cannot have branching in the View layer, it forces us to think how to make that logic testable
        and how to make it part of the state of the ViewModel.

        If you are seeing this error -- consider how you might put this component into the design system
        """

    override class func spec() {
        Given("All if statements in the screens package") {
            let withoutBaseline = HarmonizeTravelAdvisories.presentationFeaturePackage
                .views
                .withoutName(baseline)
            let screenFunctions = withoutBaseline.functions()
            let screenGetters = withoutBaseline.variables().filter { $0.hasGetterBlock() }

            Then("It has #available") {
                screenFunctions.filter { !ifsOnlyCheckAvailable($0) }.assertEmpty(message: message)
                screenGetters.filter {
                    guard let getter = $0.getter else { return false }
                    return !ifsOnlyCheckAvailable(getter)
                }
                .assertEmpty(message: message)
            }
        }
    }

    private class func ifsOnlyCheckAvailable(_ body: BodyProviding) -> Bool {
        body.ifs().allSatisfy {
            $0.conditions.description.contains("#available")
        } && body.closures().allSatisfy { klosure in
            ifsOnlyCheckAvailable(klosure)
        }
    }

    // Many of these should have been moved into the design system
    static let baseline: [String] = [
        "XXX"
    ]
}
