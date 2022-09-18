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

final class CountrySelectingRepositoryTests: QuickSpec {
    override func spec() {
        describe("CountrySelectingRepository") {
            var container: Container!
            var repository: CountrySelectingRepository!
            var mockAppScheduler: MockAppSchedulerProviding!
            var api: MockTravelAdvisoryApi!
            var continentsRecorder: Recorder<[Continent], Never>!
            var continents: [Continent]!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                repository = container.resolve(CountrySelectingRepository.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! MockTravelAdvisoryApi)

                continentsRecorder = repository.$continents.record()
                continents = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
            }

            it("then continents starts empty") {
                expect(continents.count).to(equal(0))
            }

            describe("#reload") {
                var recorder: Recorder<Void, CountrySelectingRepositoryError>!
                var completion: Subscribers.Completion<CountrySelectingRepositoryError>!
                var apiResult: Result<CountryListDTO, TravelAdvisoryApiError>?

                beforeEach {
                    api.getCountryListResult = apiResult
                    recorder = repository.reload().record()
                    mockAppScheduler.testScheduler.advance()
                }

                fcontext("success") {
                    assignBefore {
                        apiResult = nil // use default success
                    }

                    beforeEach {
                        _ = try! QuickSpec.current.wait(for: recorder.next(), timeout: 5.0)
                        continents = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then value is set") {
                        expect(continents.count).to(equal(5))
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
                        apiResult = .failure(.networkError)
                    }

                    beforeEach {
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then recorder has failed") {
                        switch completion {
                        case .failure(let error):
                            expect(error).to(equal(.apiError(innerError: .networkError)))
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
