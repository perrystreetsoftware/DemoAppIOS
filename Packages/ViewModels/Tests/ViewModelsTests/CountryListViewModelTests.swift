//
//  File.swift
//
//
//  Created by Eric Silverberg on Sep 18, 2022
//

import Quick
import Nimble
import Swinject
import Foundation
import DomainModels
import CombineExpectations
import Interfaces
import InterfaceMocks
import Logic
import Combine
import UtilsTestExtensions
import SwinjectAutoregistration
import Repositories

@testable import ViewModels
import FrameworkProviderTestFactories

final class CountryListViewModelTests: QuickSpec {
    override class func spec() {
        describe("CountryListViewModelTests") {
            var container: Container!
            var viewModel: CountryListViewModel!
            var api: MockTravelAdvisoryApi!
            let countryToBeReturned = PassthroughSubject<CountryListDTO, TravelAdvisoryApiError>()
            let serverStatusToBeReturned = PassthroughSubject<ServerStatusDTO, TravelAdvisoryApiError>()
            var stateRecorder: Recorder<CountryListUiState, Never>!

            beforeEach {
                container = Container().injectRepositories()
                    .injectLogic()
                    .injectViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                    .injectFrameworkProviderFacades()
                    .injectFrameworkProviderMocks()

                TimeAdvancingFactory(container).save()
                
                api = container~>
                api.getCountryListPublisher = countryToBeReturned.eraseToAnyPublisher()
                api.getServerStatusPublisher = serverStatusToBeReturned.eraseToAnyPublisher()

                viewModel = container~>
                stateRecorder = viewModel.$state.record()
            }

            Then("it startings having transitioned to .loading") {
                expect(try! stateRecorder.availableElements.get()).to(equal([
                    CountryListUiState(isLoading: true, serverStatus: .Empty)]))
            }

            When("a country is returned") {
                var states: [CountryListUiState]!

                beforeEach {
                    countryToBeReturned.send(.init())
                    countryToBeReturned.send(completion: .finished)

                    states = try! stateRecorder.availableElements.get()
                }

                Then("we should emit a loading and a loaded state") {
                    expect(states[1].isLoading).to(beTrue())
                    expect(states[1].isLoaded).to(beFalse())
                    expect(states[1].continents.isEmpty).to(beFalse())
                    
                    expect(states[2].isLoading).to(beFalse())
                    expect(states[2].isLoaded).to(beTrue())
                    expect(states[2].continents.isEmpty).to(beFalse())
                }
            }

            When("I request location permissions") {
                var locationStateRecorder: Recorder<LocationUiState, Never>!

                justBeforeEach {
                    viewModel.onRefreshLocationTap()
                    locationStateRecorder = viewModel.$state.map {
                        $0.yourLocation
                    }.record()
                }

                Then("We are in an updating state") {
                    expect(locationStateRecorder.allElementsDescription) == ["updating"]
                }

                And("It is not authorized") {
                    beforeEach {
                        LocationFacadeTestFactory(container)
                            .withLocationStatusDenied()
                    }

                    And("We advance our scheduler") {
                        justBeforeEach {
                            TimeAdvancingFactory(container)
                                .advance(by: LocationRepository.LocationAuthorizationTimeout)
                                .save()
                        }

                        fThen("We get multiple errors") {
                            expect(locationStateRecorder.allElementsDescription) == [
                                "updating",
                                "error"
                            ]
                        }
                    }
                }

                And("It is authorized") {
                    beforeEach {
                        LocationFacadeTestFactory(container)
                            .withLocationAuthorizedAlways()
                            .withNextLocationEmpireState()
                    }

                    And("We receive a location after a second") {
                        justBeforeEach {
                            TimeAdvancingFactory(container).advance(by: 1.0).save()
                        }

                        Then("We get a new location") {
                            expect(locationStateRecorder.allElementsDescription) == [
                                "updating",
                                "location:40.748817,-73.985428"
                            ]
                        }
                    }
                }
            }
        }
    }
}
