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
import Mockingbird

@testable import ViewModels

final class CountryListViewModelTests: QuickSpec {
    override class func spec() {
        describe("CountryListViewModelTests") {
            var container: Container!
            var viewModel: CountryListViewModel!
            var api: TravelAdvisoryApiImplementingMock!
            let countryToBeReturned = PassthroughSubject<CountryListDTO, TravelAdvisoryApiError>()
            let serverStatusToBeReturned = PassthroughSubject<ServerStatusDTO, TravelAdvisoryApiError>()
            var stateRecorder: Recorder<CountryListViewModel.UiState, Never>!

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
                stateRecorder = viewModel.$state.record()
            }

            it("then it startings having transitioned to .loading") {
                expect(try! stateRecorder.availableElements.get()).to(equal([
                    CountryListViewModel.UiState(isLoading: true, serverStatus: .Empty)]))
            }

            context("when a country is returned") {
                var states: [CountryListViewModel.UiState]!

                beforeEach {
                    countryToBeReturned.send(.init())
                    countryToBeReturned.send(completion: .finished)

                    states = try! stateRecorder.availableElements.get()
                }

                it("then we should emit a loading and a loaded state") {
                    expect(states[1].isLoading).to(beTrue())
                    expect(states[1].isLoaded).to(beFalse())
                    expect(states[1].continents.isEmpty).to(beFalse())
                    
                    expect(states[2].isLoading).to(beFalse())
                    expect(states[2].isLoaded).to(beTrue())
                    expect(states[2].continents.isEmpty).to(beFalse())
                }
            }
        }
    }
}
