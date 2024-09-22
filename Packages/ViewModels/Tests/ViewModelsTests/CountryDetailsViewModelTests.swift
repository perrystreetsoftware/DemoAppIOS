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
import RepositoriesMocks
import UtilsTestExtensions
import FrameworkProviderMocks
import SwinjectAutoregistration

@testable import ViewModels

final class CountryDetailsViewModelTests: QuickSpec {
    override class func spec() {
        describe("CountryDetailsViewModel") {
            var container: Container!
            var viewModel: CountryDetailsViewModel!
            var api: MockTravelAdvisoryApi!
            let country = Country(regionCode: "ng")
            var elements: [CountryDetailsViewModel.State]!
            var stateRecorder: Recorder<CountryDetailsViewModel.State, Never>!
            let countryToBeReturned = PassthroughSubject<CountryDetailsDTO, TravelAdvisoryApiError>()
            
            beforeEach {
                container = Container().injectRepositories()
                    .injectLogic()
                    .injectViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                    .injectFrameworkProviderMocks()
                    .injectFrameworkProviderFacades()

                api = container~>
                api.getCountryDetailsPublisher = countryToBeReturned.eraseToAnyPublisher()
                viewModel = container.resolve(CountryDetailsViewModel.self, argument: country)
                stateRecorder = viewModel.$state.record()
            }
   
            Then("then it starts having transitioned to .loading") {
                elements = try! stateRecorder.availableElements.get()

                expect(elements).to(equal([.loading]))
            }

            Given("#state") {
                beforeEach {
                    countryToBeReturned.send(.asia)
                }

                Then("then it transitions to .loaded") {
                    elements = try! stateRecorder.availableElements.get()

                    expect(elements.count).to(equal(2))
                }

                Then("then it has loaded content") {
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
