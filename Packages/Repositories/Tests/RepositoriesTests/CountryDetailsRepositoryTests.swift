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

@testable import Repositories

final class CountryDetailsRepositoryTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsRepository") {
            var container: Container!
            var repository: CountryDetailsRepository!
            var mockAppScheduler: MockAppSchedulerProviding!
            var api: MockTravelAdvisoryApi!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                repository = container.resolve(CountryDetailsRepository.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! MockTravelAdvisoryApi)
            }

            describe("#getDetails") {
                var recorder: Recorder<CountryDetails, CountryDetailsError>!
                var completion: Subscribers.Completion<CountryDetailsError>!
                var apiResult: Result<CountryDetailsDTO, TravelAdvisoryApiError>?

                justBeforeEach {
                    api.getCountryDetailsResult = apiResult
                    recorder = repository.getDetails(regionCode: "rc").record()
                    mockAppScheduler.testScheduler.advance()
                    completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 1.0)
                }

                context("when api succeeds") {
                    var value: CountryDetails!

                    beforeEach {
                        let countryDetailsDTO = CountryDetailsDTO.fixture(regionCode: "region code value")
                        apiResult = .success(countryDetailsDTO)
                    }

                    justBeforeEach {
                        value = try! recorder.availableElements.get().last
                    }

                    it("then should return country details") {
                        let countryDetails = CountryDetails.fixture(
                            country: .fixture(regionCode: "region code value")
                        )
                        
                        expect(api.getCountryDetailsRegionCallsCount) == 1
                        expect(api.getCountryDetailsRegionCodePassed) == "rc"
                        expect(value).to(equal(countryDetails))
                    }
                }

                context("when api fails") {
                    beforeEach {
                        apiResult = .failure(.domainError(.forbidden, responseCode: .forbidden))
                    }

                    it("then should return a country details error") {
                        expect(completion.error) == CountryDetailsError.other
                    }
                }
            }
        }
    }
}
