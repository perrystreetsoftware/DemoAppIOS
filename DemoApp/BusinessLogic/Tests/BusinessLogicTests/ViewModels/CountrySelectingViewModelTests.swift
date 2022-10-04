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
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                mockAppScheduler = (container.resolve(AppSchedulerProviding.self)! as! MockAppSchedulerProviding)
                mockAppScheduler.useTestMainScheduler = true
                viewModel = container.resolve(CountrySelectingViewModel.self)!
            }

            describe("#onPageLoaded") {
                var stateRecorder: Recorder<CountrySelectingViewModel.State, Never>!
                var contentRecorder: Recorder<[Continent], Never>!

                beforeEach {
                    stateRecorder = viewModel.$state.record()
                    viewModel.onPageLoaded()
                }

                it("then it transitions to .loading") {
                    expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading]))
                }

                context("when I advance") {
                    var nextState: CountrySelectingViewModel.State!

                    beforeEach {
                        mockAppScheduler.testScheduler.advance()
                        nextState = try! QuickSpec.current.wait(for: stateRecorder.next(), timeout: 5.0)
                    }

                    it("then it transitions back to .initial") {
                        expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading, .initial]))
                    }

                    it("then it has loaded content") {
                        let continents = nextState.continents

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
