import Quick
import Nimble
import Swinject
import Foundation
import DomainModels
import Interfaces
import InterfaceMocks
import Logic
import Combine
@testable import Feature
import ViewModels
import UtilsTestExtensions
import SwinjectAutoregistration
import FrameworkProviderMocks

final class CountryListErrorTests: QuickSpec {
    override class func spec() {
        describe("CountryListError") {
            var container: Container!
            var viewModel: CountryListViewModel!
            var api: MockTravelAdvisoryApi!
            let serverStatusToBeReturned = PassthroughSubject<ServerStatusDTO, TravelAdvisoryApiError>()
            let countryToBeReturned = PassthroughSubject<CountryListDTO, TravelAdvisoryApiError>()

            beforeEach {
                container = Container().injectRepositories()
                    .injectLogic()
                    .injectViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                    .injectFrameworkProviderFacades()
                    .injectFrameworkProviderMocks()

                api = container~>

                api.getCountryListPublisher = countryToBeReturned.eraseToAnyPublisher()
                api.getServerStatusPublisher = serverStatusToBeReturned.eraseToAnyPublisher()

                viewModel = container.resolve(CountryListViewModel.self)!
            }
            
            Then("Blocked error shows a dialog with a positive action"){
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
