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

            let country = CountryUIModel(regionCode: "ng")

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                viewModelBuilder = container.resolve(CountryDetailsViewModelBuilder.self)!
                viewModel = viewModelBuilder.build(country: country)
            }

            describe("#onAppear") {
                var stateRecorder: Recorder<CountryDetailsViewModel.State, Never>!
                var detailsRecorder: Recorder<CountryDetailsUIModel?, Never>!

                beforeEach {
                    stateRecorder = viewModel.$state.record()
                    detailsRecorder = viewModel.$details.record()
                    viewModel.onAppear()
                }

                it("then it transitions to .loading") {
                    expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading]))
                }

                it("then it has not loaded content") {
                    expect(viewModel.details).to(beNil())
                }

                context("when I advance") {
                    beforeEach {
                        mockAppScheduler.testScheduler.advance()
                    }

                    it("then it transitions back to .initial") {
                        expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading, .initial]))
                    }

                    it("then it has loaded content") {
                        expect(viewModel.details).notTo(beNil())
                        expect(try! detailsRecorder.availableElements.get()).to(equal([nil, CountryDetailsUIModel(regionCode: "YE", detailsText: "Article 264")]))
                    }
                }
            }
        }
    }
}
