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

final class CountryDetailsViewModelTests: QuickSpec {
    override func spec() {
        describe("CountryDetailsViewModel") {
            var container: Container!
            var viewModelBuilder: CountryDetailsViewModelBuilder!
            var viewModel: CountryDetailsViewModel!
            var mockAppScheduler: MockAppSchedulerProviding!

            let country = Country(regionCode: "ng")

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
//                mockAppScheduler.useTestMainScheduler = true
                viewModelBuilder = container.resolve(CountryDetailsViewModelBuilder.self)!
                viewModel = viewModelBuilder.build(country: country)
            }

            describe("#onPageLoaded") {
                var stateRecorder: Recorder<CountryDetailsViewModel.State, Never>!
                var detailsRecorder: Recorder<CountryDetails?, Never>!

                beforeEach {
                    stateRecorder = viewModel.$state.record()
                    detailsRecorder = viewModel.$details.record()
                    viewModel.onPageLoaded()
                }

                it("then it transitions to .loading") {
                    expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading]))
                }

                it("then it has not loaded content") {
                    expect(viewModel.details).to(beNil())
                }

                context("when I advance") {
                    beforeEach {
                        _ = try! QuickSpec.current.wait(for: stateRecorder.next(3), timeout: 5.0)
//                        mockAppScheduler.testScheduler.advance()
                    }

                    it("then it transitions back to .initial") {
                        expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading, .initial]))
                    }

                    it("then it has loaded content") {
                        expect(viewModel.details).notTo(beNil())
                        expect(try! detailsRecorder.availableElements.get()).to(equal([nil,
                                                                                       CountryDetails(country: Country(regionCode: "YE"), detailsText: "Article 264")]))
                    }
                }
            }
        }
    }
}
