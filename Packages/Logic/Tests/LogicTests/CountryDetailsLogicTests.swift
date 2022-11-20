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
import InterfacesMocks
import Combine
import Mockingbird
import RepositoriesMocks

@testable import Logic

final class CountryDetailsLogicTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsLogic") {
            var container: Container!
            var logic: CountryDetailsLogic!
            var mockAppScheduler: MockAppSchedulerProviding!
            var api: TravelAdvisoryApiImplementingMock!

            let country = Country(regionCode: "ng")


            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                logic = container.resolve(CountryDetailsLogic.self)!
                api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
            }

            describe("#getDetails") {
                var recorder: Recorder<CountryDetails, CountryDetailsError>!
                var completion: Subscribers.Completion<CountryDetailsError>!

                beforeEach {
                    let publisherToBeReturned = Just(CountryDetailsDTO.asia)
                        .setFailureType(to: TravelAdvisoryApiError.self)
                        .eraseToAnyPublisher()
                    
                    given(api.getCountryDetails(regionCode: "ng")).willReturn(publisherToBeReturned)
                    recorder = logic.getDetails(country: country).record()
                    mockAppScheduler.testScheduler.advance()
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

extension CountryDetailsDTO {
    static var asia: Self {
        CountryDetailsDTO(
            area: "Asia",
            regionName: Locale.current.localizedString(forRegionCode: "ng")!,
            regionCode: "ng",
            legalCodeBody: "Article 264"
        )
    }
}
