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

final class CountryDetailsLogicTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsLogic") {
            var container: Container!
            var logic: CountryDetailsLogic!
            var mockAppScheduler: MockAppSchedulerProviding!

            let country = CountryUIModel(regionCode: "ng")


            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                logic = container.resolve(CountryDetailsLogic.self)!
            }

            describe("#getDetails") {
                var recorder: Recorder<CountryDetailsUIModel, CountryDetailsLogicError>!
                var completion: Subscribers.Completion<CountryDetailsLogicError>!

                beforeEach {
                    recorder = logic.getDetails(country: country).record()
                    mockAppScheduler.testScheduler.advance()
                }

                context("success") {
                    var value: CountryDetailsUIModel!

                    beforeEach {
                        value = try! QuickSpec.current.wait(for: recorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then value is set") {
                        expect(value).to(equal(CountryDetailsUIModel(regionCode: "YE", detailsText: "Article 264")))
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
