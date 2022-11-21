//
//  CountryDetailsRepositoryTests.swift
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
import Combine
import Mockingbird
import InterfacesMocks
import RepositoriesMocks
import XCTest

@testable import Repositories

final class CountryDetailsRepositoryTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsRepository") {
            var container: Container!
            var repository: CountryDetailsRepository!
            var api: TravelAdvisoryApiImplementingMock!
            
            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                repository = container.resolve(CountryDetailsRepository.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
            }

            describe("#getDetails") {
                var recorder: Recorder<CountryDetails, CountryDetailsError>!
                var completion: Subscribers.Completion<CountryDetailsError>!

                justBeforeEach {
                    recorder = repository.getDetails(regionCode: "rc").record()
                    completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 1.0)
                }

                context("when api succeeds") {
                    var value: CountryDetails!

                    beforeEach {
                        let country = CountryDetailsDTO.fixture(regionCode: "region code value")
                        given(api.getCountryDetails(regionCode: "rc")).willReturn(.just(country))
                    }
                    
                    justBeforeEach {
                        value = try! recorder.availableElements.get().last
                    }

                    it("then should return country details") {
                        let countryDetails = CountryDetails.fixture(
                            country: .fixture(regionCode: "region code value")
                        )
                        
                        verify(api.getCountryDetails(regionCode: "rc")).wasCalled(1)
                        expect(value).to(equal(countryDetails))
                    }
                }

                context("when api fails") {
                    beforeEach {
                        let forbiddenError = TravelAdvisoryApiError.domainError(.forbidden, responseCode: .forbidden)
                        given(api.getCountryDetails(regionCode: "rc")).willReturn(.error(forbiddenError))
                    }

                    it("then should return a country details error") {
                        expect(completion.error) == CountryDetailsError.other
                    }
                }
            }
        }
    }
}
