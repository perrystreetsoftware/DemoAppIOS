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
import Mockingbird
import InterfaceMocks
import SwinjectAutoregistration

final class CountryListRepositoryTests: QuickSpec {
    override func spec() {
        describe("CountryListRepository") {
            var container: Container!
            var repository: CountryListRepository!
            var api: TravelAdvisoryApiImplementingMock!
            var continentsRecorder: Recorder<[Continent], Never>!
            var continents: [Continent]!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                repository = container.resolve(CountryListRepository.self)!
                api = container ~~> TravelAdvisoryApiImplementing.self

                continentsRecorder = repository.$continents.record()
                continents = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
            }

            it("then continents starts empty") {
                expect(continents.count).to(equal(0))
            }

            describe("#reload") {
                var recorder: Recorder<Void, CountryListError>!
                var completion: Subscribers.Completion<CountryListError>!

                context("success") {
               
                    justBeforeEach {
                        _ = try! QuickSpec.current.wait(for: recorder.next(), timeout: 5.0)
                        continents = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    beforeEach {
                        given(api.getCountryList()).willReturn(.just(.init()))
                        recorder = repository.reload().record()
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
                        given(api.getCountryList()).willReturn(.error(TravelAdvisoryApiError(statusCode: 10)))
                        recorder = repository.reload().record()
                    }

                    justBeforeEach {
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then recorder has failed") {
                        switch completion {
                        case .failure:
                            return
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
