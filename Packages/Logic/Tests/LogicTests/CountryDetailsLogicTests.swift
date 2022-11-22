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
import RepositoriesMocks

@testable import Logic

final class CountryDetailsLogicTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsLogic") {
            var container: Container!
            var logic: CountryDetailsLogic!
            var api: TravelAdvisoryApiImplementingMock!

            let country = Country(regionCode: "ng")

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                logic = container.resolve(CountryDetailsLogic.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
            }

            describe("#getDetails") {
                var recorder: Recorder<CountryDetails, CountryDetailsError>!
                var completion: Subscribers.Completion<CountryDetailsError>!

                beforeEach {
                    given(api.getCountryDetails(regionCode: "ng")).willReturn(.just(.asia))
                    recorder = logic.getDetails(country: country).record()
                }

                context("success") {
                    var value: CountryDetails!

                    beforeEach {
                        value = try! QuickSpec.current.wait(for: recorder.next(), timeout: 5.0)
                        completion = try! QuickSpec.current.wait(for: recorder.completion, timeout: 5.0)
                    }

                    it("then value is set") {
                        expect(value).to(equal(CountryDetails(country: country, detailsText: "Article 264")))
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
