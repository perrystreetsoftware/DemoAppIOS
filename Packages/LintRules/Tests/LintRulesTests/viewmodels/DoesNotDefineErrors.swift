import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoesNotDefineErrors: QuickSpec {
    override class func spec() {
        Given("An error enum defined in the project") {
            let errors = HarmonizeTravelAdvisories.productionCode.enums()
                .conforming(to: Error.self)

            When("A ViewModel conforms or refers to it") {
                let viewModels = HarmonizeTravelAdvisories.viewModelsPackage
                    .classes(includeNested: true)

                Then("There is no published variable exposing it") {
                    viewModels.assertTrue(message: publishedErrorMessage, baseline: baseline) { viewModel in
                        viewModel.variables
                            .withAttribute(annotatedWith: .published)
                            .withType { type in
                                errors.contains { error in
                                    error.name == type.name.replacingOccurrences(of: "?", with: "")
                                }
                            }
                            .isEmpty
                    }
                }
            }

            When("There is an Enum wrapping the error") {
                let enums = HarmonizeTravelAdvisories.productionCode.enums()
                    .withSuffix("Error")
                    .withNameContaining("ViewModel")

                Then("It is defined within the ViewModel") {
                    enums.assertTrue(message: wrappedErrorMessage) {
                        $0.parent != nil && ($0.parent as? Class)?.name.contains("ViewModel") == true
                    }
                }
            }

            When("There is an error Enum defined within a ViewModel") {
                let viewModelEnums = HarmonizeTravelAdvisories.viewModelsPackage
                    .enums()
                    .withSuffix("Error")

                Then("It is named Error") {
                    viewModelEnums.assertTrue(message: errorNamingMessage) {
                        $0.name == "Error"
                    }
                }
            }
        }
    }

    private static let publishedErrorMessage = LintRuleMessage(
        rule: "ViewModels must not expose domain error enums through @Published variables.",
        why: """
            Publishing raw domain errors from a ViewModel leaks the domain error type into \
            the view layer, and encourages views to branch on error cases. Errors should \
            flow through the shared error-publishing mechanism so they are rendered \
            consistently (dialogs, toasts) across the app.
            """,
        howToFix: """
            Remove the @Published domain-error variable and map the error into the UiState \
            (for example a DialogUiState or ToastUiState) instead.
            """,
        badExample: """
            public final class CountryListViewModel: ObservableObject {
                @Published public var error: CountryListError? = nil
            }
            """,
        goodExample: """
            public final class CountryListViewModel: ObservableObject {
                @Published public var state: CountryListUiState = CountryListUiState()
                // errors are mapped into state.dialogState / state.toastState
            }
            """
    )

    private static let wrappedErrorMessage = LintRuleMessage(
        rule: "Error enums whose name references a ViewModel must be nested inside that ViewModel.",
        why: """
            An error type that exists only for a ViewModel belongs to that ViewModel. \
            Defining it at the top level pollutes the module namespace and makes the \
            ownership unclear.
            """,
        howToFix: "Move the enum inside the ViewModel class declaration.",
        badExample: """
            enum CountryListViewModelError: Error { case notFound }

            public final class CountryListViewModel: ObservableObject { ... }
            """,
        goodExample: """
            public final class CountryListViewModel: ObservableObject {
                enum Error: Swift.Error { case notFound }
            }
            """
    )

    private static let errorNamingMessage = LintRuleMessage(
        rule: "Error enums defined within a ViewModel must be named exactly `Error`.",
        why: """
            Nesting already provides the namespace (`CountryListViewModel.Error`), so \
            prefixes or suffixes are redundant and inconsistent.
            """,
        howToFix: "Rename the nested enum to `Error` (referencing `Swift.Error` for the conformance).",
        badExample: """
            public final class CountryListViewModel: ObservableObject {
                enum CountryListError: Swift.Error { case notFound }
            }
            """,
        goodExample: """
            public final class CountryListViewModel: ObservableObject {
                enum Error: Swift.Error { case notFound }
            }
            """
    )

    private static let baseline = ["CountryListViewModel.swift"]
}
