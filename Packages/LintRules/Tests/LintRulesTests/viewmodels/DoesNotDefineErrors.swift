import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class DoesNotDefineErrors: QuickSpec {
    private static let baseline = ["CountryListViewModel"]
    
    override class func spec() {
        Given("An error enum defined in the project") {
            let errors = Harmonize.productionCode().enums()
                .conforming(to: Error.self)
            
            When("A ViewModel conforms or refers to it") {
                let viewModelErrors = Harmonize.on("ViewModels")
                    .classes()
                    .withoutName(baseline)
                    .variables()
                    .withAttribute(annotatedWith: .published)
                    .withType { type in
                        errors.contains { error in
                            error.name == type.name.replacingOccurrences(of: "?", with: "")
                        }
                    }
                
                Then("There is no published variable exposing it") {
                    viewModelErrors.assertEmpty(message: "Do not define a ViewModel State error publisher; use the published error variable instead from LifecycleViewModel.")
                }
            }
            
            When("There is an Enum wrapping the error") {
                let enums = Harmonize.productionCode().enums()
                    .withSuffix("Error")
                    .withNameContaining("ViewModel")

                Then("It is defined within the ViewModel") {
                    enums.assertTrue(message: "Wrapped errors must be defined within the ViewModel") {
                        $0.parent != nil && ($0.parent as? Class)?.name.contains("ViewModel") == true
                    }
                }
            }
            
            When("There is an error Enum defined within a ViewModel") {
                let viewModelEnums = Harmonize.productionCode().on("ViewModels")
                    .enums()
                    .withSuffix("Error")
                
                Then("It is named Error") {
                    viewModelEnums.assertTrue(message: "Error enums must be named Error and do not have a suffix or prefix.") {
                        $0.name == "Error"
                    }
                }
            }
        }
    }
}
