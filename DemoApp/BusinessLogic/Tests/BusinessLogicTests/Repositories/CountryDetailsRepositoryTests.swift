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
@testable import BusinessLogic
import Combine

final class CountryDetailsRepositoryTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsRepository") {
            var container: Container!
            var repository: CountryDetailsRepository!
            var mockAppScheduler: MockAppSchedulerProviding!
            var api: MockTravelAdvisoryApi!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                repository = container.resolve(CountryDetailsRepository.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! MockTravelAdvisoryApi)
            }

            describe("#getDetails") {
                var recorder: Recorder<CountryDetailsDTO, TravelAdvisoryApiError>!
                var completion: Subscribers.Completion<TravelAdvisoryApiError>!
                var apiResult: Result<CountryDetailsDTO, TravelAdvisoryApiError>?

                justBeforeEach {
                    api.getCountryDetailsResult = apiResult
                    recorder = repository.getDetails(regionCode: "ng").record()
                    mockAppScheduler.testScheduler.advance()
                    completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                }

                context("success") {
                    var value: CountryDetailsDTO!

                    beforeEach {
                        apiResult = nil // use default success
                    }

                    justBeforeEach {
                        value = try! recorder.availableElements.get().last
                    }

                    it("then value is set") {
                        expect(value).to(equal(CountryDetailsDTO(area: "Asia", regionName: "Nigeria", regionCode: "ng", legalCodeBody: "Article 264")))
                    }

                    it("then recorder has completed") {
                        switch completion {
                        case .failure:
                            fail("Unexpected state")
                        case .finished:
                            // ok
                            break
                        case .none:
                            fail("Unexpected state")
                        }
                    }
                }

                context("failure") {
                    beforeEach {
                        apiResult = .failure(.domainError(.forbidden, responseCode: .forbidden))
                    }

                    justBeforeEach {
                    }

                    it("then recorder has failed") {
                        switch completion {
                        case .failure(let error):
                            expect(error).to(equal(TravelAdvisoryApiError.domainError(.forbidden, responseCode: .forbidden)))
                        case .finished:
                            fail("Unexpected state")
                        case .none:
                            fail("Unexpected state")
                        }
                    }
                }
            }
        }
    }
}
