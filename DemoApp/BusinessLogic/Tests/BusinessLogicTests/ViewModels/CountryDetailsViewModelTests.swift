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

            let country = Country(regionCode: "ng")

            beforeEach {
                container = Container().injectBusinessLogicRepositories()
                    .injectBusinessLogicLogic()
                    .injectBusinessLogicViewModels()
                    .injectInterfaceLocalMocks()
                    .injectInterfaceRemoteMocks()
                viewModelBuilder = container.resolve(CountryDetailsViewModelBuilder.self)!
                viewModel = viewModelBuilder.build(country: country)
            }

            describe("#onPageLoaded") {
                var stateRecorder: Recorder<CountryDetailsViewModel.State, Never>!

                beforeEach {
                    stateRecorder = viewModel.$state.record()
                    viewModel.onPageLoaded()
                }

                it("then it transitions to .loading") {
                    expect(try! stateRecorder.availableElements.get()).to(equal([.initial, .loading]))
                }

                context("when I advance") {
                    beforeEach {
                        _ = try! QuickSpec.current.wait(for: stateRecorder.next(3), timeout: 5.0)
                    }

                    it("then it transitions to .loaded") {
                        let last = try! stateRecorder.availableElements.get().last
                        let details = CountryDetails(country: country, detailsText: "Article 264")

                        expect(last).to(equal(.loaded(details: details)))
                    }

                    it("then it has loaded content") {
                        expect(viewModel.state.countryName).to(equal("Nigeria"))
                        expect(viewModel.state.countryDetails).to(equal("Article 264"))
                    }
                }
            }
        }
    }
}
