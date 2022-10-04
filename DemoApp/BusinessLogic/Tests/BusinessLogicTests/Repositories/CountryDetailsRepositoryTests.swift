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
                    .injectBusinessLogicViewModels()
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

                beforeEach {
                    api.getCountryDetailsResult = apiResult
                    recorder = repository.getDetails(regionCode: "ng").record()
                    mockAppScheduler.testScheduler.advance()
                }

                context("success") {
                    var value: CountryDetailsDTO!

                    assignBefore {
                        apiResult = nil // use default success
                    }

                    beforeEach {
                        value = try! QuickSpec.current.wait(for: recorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then value is set") {
                        expect(value).to(equal(CountryDetailsDTO(area: "Asia", regionName: "Yemen", regionCode: "YE", legalCodeBody: "Article 264")))
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
                    assignBefore {
                        apiResult = .failure(.domainError(.forbidden, responseCode: .forbidden))
                    }

                    beforeEach {
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
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
