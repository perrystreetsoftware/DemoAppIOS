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
import Combine
import Mockingbird

@testable import Logic

final class CountryListLogicTests: QuickSpec {
    override func spec() {
        describe("CountryListLogic") {
            var container: Container!
            var logic: CountryListLogic!
            var continentsRecorder: Recorder<[Continent], Never>!
            var value: [Continent]!
            var api: TravelAdvisoryApiImplementingMock!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                logic = container.resolve(CountryListLogic.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)

                continentsRecorder = logic.$continents.record()
                value = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
            }

            it("then it starts with no continents") {
                expect(value.count).to(equal(0))
            }

            describe("#reload") {
                var recorder: Recorder<Void, CountryListError>!
                var completion: Subscribers.Completion<CountryListError>!

                beforeEach {
                    given(api.getCountryList()).willReturn(.just(.init()))
                    
                    recorder = logic.reload().record()
                }

                context("success") {
                    var value: [Continent]!

                    beforeEach {
                        value = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then value is set") {
                        expect(value.count).to(equal(6))
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
            }
        }
    }
}
