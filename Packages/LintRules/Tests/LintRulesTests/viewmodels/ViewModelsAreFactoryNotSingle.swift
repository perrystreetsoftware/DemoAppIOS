//
//  ViewModelsAreFactoryNotSingle.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class ViewModelsAreFactoryNotSingle: QuickSpec {
    override class func spec() {
        Given("A ViewModel") {
            let viewModels = HarmonizeTravelAdvisories.viewModelsProduction

            Then("it is annotated with @Factory") {
                viewModels.filter { $0.attributes.isNotEmpty }.assertTrue(message: message) {
                    $0.hasAttribute(named: "@Factory")
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "ViewModels must be registered with @Factory, never @Single.",
        why: """
            A ViewModel's lifecycle belongs to the screen that owns it: views resolve it \
            via @InjectStateObject, which expects a fresh instance per screen. Registering \
            a ViewModel as @Single turns it into an app-wide singleton — state leaks \
            between screen visits, cancellables never reset, and two screens can fight \
            over the same published state.
            """,
        howToFix: """
            Replace the @Single annotation with @Factory so the DI container produces a \
            new instance each time the screen is created.
            """,
        badExample: """
            @Single
            public final class CountryListViewModel: ObservableObject { ... }
            """,
        goodExample: """
            @Factory
            public final class CountryListViewModel: ObservableObject { ... }
            """
    )
}
