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
import InterfacesMocks
import Logic
import Combine
import Mockingbird
import RepositoriesMocks
@testable import ViewModels

final class CountryDetailsViewModelTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsViewModel") {
            var container: Container!
            var viewModel: CountryDetailsViewModel!
            var api: TravelAdvisoryApiImplementingMock!
            let country = Country(regionCode: "ng")
            var elements: [CountryDetailsViewModel.State]!
            var stateRecorder: Recorder<CountryDetailsViewModel.State, Never>!
            let countryToBeReturned = PassthroughSubject<CountryDetailsDTO, TravelAdvisoryApiError>()
            
            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
                given(api.getCountryDetails(regionCode: "ng")).willReturn(countryToBeReturned.eraseToAnyPublisher())
                viewModel = container.resolve(CountryDetailsViewModel.self, argument: country)
                stateRecorder = viewModel.$state.record()
            }
   
            it("then it starts having transitioned to .loading") {
                elements = try! stateRecorder.availableElements.get()

                expect(elements).to(equal([.loading]))
            }

            context("#state") {
                beforeEach {
                    countryToBeReturned.send(.asia)
                }

                it("then it transitions to .loaded") {
                    elements = try! stateRecorder.availableElements.get()

                    expect(elements.count).to(equal(2))
                }

                it("then it has loaded content") {
                    switch viewModel.state {
                    case .loaded(let details):
                        expect(details.country.countryName).to(equal("Nigeria"))
                        expect(details.detailsText).to(equal("Article 264"))
                        break
                    default:
                        fail("Unexpected state")
                    }
                }
            }
        }
    }
}
