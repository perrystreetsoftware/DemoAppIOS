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
@testable import Logic
import Combine

final class CountryListLogicTests: QuickSpec {
    override func spec() {
        describe("CountryListLogic") {
            var container: Container!
            var logic: CountryListLogic!
            var mockAppScheduler: MockAppSchedulerProviding!
            var continentsRecorder: Recorder<[Continent], Never>!
            var value: [Continent]!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                logic = container.resolve(CountryListLogic.self)!

                continentsRecorder = logic.$continents.record()
                value = try! QuickSpec.current.wait(for: continentsRecorder.next(), timeout: 5.0)
            }

            it("then it starts with no continents") {
                expect(value.count).to(equal(0))
            }

            describe("#reload") {
                var recorder: Recorder<Void, CountryListLogicError>!
                var completion: Subscribers.Completion<CountryListLogicError>!

                beforeEach {
                    recorder = logic.reload().record()
                    mockAppScheduler.testScheduler.advance()
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
