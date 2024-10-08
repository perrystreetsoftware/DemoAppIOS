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
import UtilsTestExtensions
import SwinjectAutoregistration

@testable import Logic

final class CountryListLogicTests: QuickSpec {
    override class func spec() {
        describe("CountryListLogic") {
            var container: Container!
            var logic: CountryListLogic!
            var continentsRecorder: Recorder<[Continent], Never>!
            var value: [Continent]!
            var api: MockTravelAdvisoryApi!

            beforeEach {
                container = Container().injectRepositories()
                    .injectLogic()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                logic = container~>
                api = container~>

                continentsRecorder = logic.$continents.record()
                value = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
            }

            Then("then it starts with no continents") {
                expect(value.count).to(equal(0))
            }

            When("#reload") {
                var recorder: Recorder<Void, CountryListError>!
                var completion: Subscribers.Completion<CountryListError>!

                beforeEach {
                    api.getCountryListResult = .success(.init())
                    
                    recorder = logic.reload().record()
                }

                When("success") {
                    var value: [Continent]!

                    beforeEach {
                        value = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    Then("value is set") {
                        expect(value.count).to(equal(6))
                    }

                    Then("recorder has completed") {
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
