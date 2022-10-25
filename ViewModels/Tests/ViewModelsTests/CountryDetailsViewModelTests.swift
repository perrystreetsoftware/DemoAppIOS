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
import BusinessLogic
@testable import ViewModels

final class CountryDetailsViewModelTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsViewModel") {
            var container: Container!
            var viewModelBuilder: CountryDetailsViewModelBuilder!
            var viewModel: CountryDetailsViewModel!
            var scheduler: MockAppSchedulerProviding!

            let country = Country(regionCode: "ng")

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                scheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                scheduler.useTestMainScheduler = true
                viewModelBuilder = container.resolve(CountryDetailsViewModelBuilder.self)!
                viewModel = viewModelBuilder.build(country: country)
            }

            var stateRecorder: Recorder<CountryDetailsViewModel.State, Never>!
            var elements: [CountryDetailsViewModel.State]!

            beforeEach {
                stateRecorder = viewModel.$state.record()
                elements = try! stateRecorder.availableElements.get()
            }

            it("then it transitions to .loading") {
                expect(elements).to(equal([.loading]))
            }

            context("when I advance") {
                beforeEach {
                    scheduler.testScheduler.advance()
                    _ = try! QuickSpec.current.wait(for: stateRecorder.next(), timeout: 5.0)
                }

                it("then it transitions to .loaded") {
                    let last = try! stateRecorder.availableElements.get().last
                    let details = CountryDetails(country: country, detailsText: "Article 264")

                    expect(last).to(equal(.loaded(details: details)))
                }

                it("then it has loaded content") {
                    switch viewModel.state {
                    case .loaded(let details):
                        expect(details.country.countryName).to(equal("Nigeria"))
                        expect(details.detailsText).to(equal("Article 264"))
                        break
                    default:
                        fail("Unexpected state")
                    }
                }
            }
        }
    }
}
