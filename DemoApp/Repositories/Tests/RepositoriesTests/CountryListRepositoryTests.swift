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
import Combine
import Repositories

final class CountryListRepositoryTests: QuickSpec {
    override func spec() {
        describe("CountryListRepository") {
            var container: Container!
            var repository: CountryListRepository!
            var mockAppScheduler: MockAppSchedulerProviding!
            var api: MockTravelAdvisoryApi!
            var continentsRecorder: Recorder<[Continent], Never>!
            var continents: [Continent]!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                repository = container.resolve(CountryListRepository.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! MockTravelAdvisoryApi)

                continentsRecorder = repository.$continents.record()
                continents = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
            }

            it("then continents starts empty") {
                expect(continents.count).to(equal(0))
            }

            describe("#reload") {
                var recorder: Recorder<Void, CountryListRepositoryError>!
                var completion: Subscribers.Completion<CountryListRepositoryError>!
                var apiResult: Result<CountryListDTO, TravelAdvisoryApiError>?

                beforeEach {
                    api.getCountryListResult = apiResult
                    recorder = repository.reload().record()
                    mockAppScheduler.testScheduler.advance()
                }

                fcontext("success") {
                    beforeEach {
                        apiResult = nil // use default success
                    }

                    justBeforeEach {
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
                    beforeEach {
                        apiResult = .failure(.domainError(.forbidden, responseCode: .forbidden))
                    }

                    justBeforeEach {
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

//                    it("then recorder has failed") {
//                        switch completion {
//                        case .failure(let error):
//                            expect(error).to(equal(TravelAdvisoryApiError.domainError(.forbidden, responseCode: .forbidden)))
//                        case .finished:
//                            fail("Unexpected state")
//                        case .none:
//                            fail("Unexpected state")
//                        }
//                    }
                }
            }
        }
    }
}
