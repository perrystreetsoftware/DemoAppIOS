import Quick
import Nimble
import Swinject
import Foundation
import DomainModels
import Interfaces
import InterfaceMocks
import Logic
import Combine
import Mockingbird
@testable import Feature
import ViewModels

final class CountryListErrorTests: QuickSpec {
    override func spec() {
        describe("CountryListError") {
            var container: Container!
            var viewModel: CountryListViewModel!
            var api: TravelAdvisoryApiImplementingMock!
            let serverStatusToBeReturned = PassthroughSubject<ServerStatusDTO, TravelAdvisoryApiError>()
            let countryToBeReturned = PassthroughSubject<CountryListDTO, TravelAdvisoryApiError>()

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
                
                given(api.getCountryList()).willReturn(countryToBeReturned.eraseToAnyPublisher())
                given(api.getServerStatus()).willReturn(serverStatusToBeReturned.eraseToAnyPublisher())
                

                viewModel = container.resolve(CountryListViewModel.self)!
            }
            
            it("Blocked error shows a dialog with a positive action"){
                let floatingAlert = CountryListError.blocked.asFloatingAlert(viewModel: viewModel, onAboutThisAppSelected: {})
                
                switch floatingAlert {
                case .dialog(let state):
                    expect(state.positiveAction).notTo(beNil())
                case .toast(_):
                    fail("was expecting a dialog")
                }
            }
        }
    }
}
