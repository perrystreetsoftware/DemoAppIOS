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

final class CountrySelectingViewModelTests: QuickSpec {
    override func spec() {
        describe("CountrySelectingViewModel") {
            var container: Container!
            var viewModel: CountrySelectingViewModel!
            var mockAppScheduler: MockAppSchedulerProviding!

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                viewModel = container.resolve(CountrySelectingViewModel.self)!
            }

            describe("#onAppear") {
                var stateRecorder: Recorder<CountrySelectingViewModel.State, Never>!
                var contentRecorder: Recorder<[ContinentUIModel], Never>!

                beforeEach {
                    stateRecorder = viewModel.$state.record()
                    contentRecorder = viewModel.$continents.record()
                    viewModel.onAppear()
                }

                it("then it transitions to .loading") {
                    expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading]))
                }

                it("then it has not loaded content") {
                    expect(viewModel.continents).to(equal([]))
                }

                context("when I advance") {
                    beforeEach {
                        mockAppScheduler.testScheduler.advance()
                    }

                    it("then it transitions back to .initial") {
                        expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading, .initial]))
                    }

                    it("then it has loaded content") {
                        expect(viewModel.continents.count).to(beGreaterThan(0))

                        let continents = (try! contentRecorder.availableElements.get()).last!

                        expect(continents.count).to(equal(5))
                        expect(continents.first { uiModel in
                            uiModel.name == "Africa"
                        }?.countries.count).to(equal(2))
                    }
                }
            }
        }
    }
}
