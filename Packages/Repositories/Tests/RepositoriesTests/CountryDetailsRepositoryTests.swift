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
import InterfaceMocks
import RepositoriesMocks
import XCTest
import UtilsTestExtensions
import SwinjectAutoregistration

@testable import Repositories

final class CountryDetailsRepositoryTests: QuickSpec {
    override class func spec() {
        describe("CountryDetailsRepository") {
            var container: Container!
            var repository: CountryDetailsRepository!
            var api: TravelAdvisoryApiImplementingMock!
            
            beforeEach {
                container = Container().injectRepositories()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                repository = container~>
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
            }

            Given("#getDetails") {
                var recorder: Recorder<CountryDetails, CountryDetailsError>!
                var completion: Subscribers.Completion<CountryDetailsError>!

                justBeforeEach {
                    recorder = repository.getDetails(regionCode: "rc").record()
                    completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 1.0)
                }

                When("api succeeds") {
                    var value: CountryDetails!

                    beforeEach {
                        let country = CountryDetailsDTO.fixture(regionCode: "region code value")
                        given(api.getCountryDetails(regionCode: "rc")).willReturn(.just(country))
                    }
                    
                    justBeforeEach {
                        value = try! recorder.availableElements.get().last
                    }

                    Then("should return country details") {
                        let countryDetails = CountryDetails.fixture(
                            country: .fixture(regionCode: "region code value")
                        )
                        
                        verify(api.getCountryDetails(regionCode: "rc")).wasCalled(1)
                        expect(value).to(equal(countryDetails))
                    }
                }

                When("api fails") {
                    beforeEach {
                        let forbiddenError = TravelAdvisoryApiError.domainError(.forbidden, responseCode: .forbidden)
                        given(api.getCountryDetails(regionCode: "rc")).willReturn(.error(forbiddenError))
                    }

                    Then("should return a country details error") {
                        expect(completion.error) == CountryDetailsError.other
                    }
                }
            }
        }
    }
}
