//
//  LocationRepositoryTests.swift
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
import Combine
import Repositories
import Mockingbird
import InterfaceMocks
import UtilsTestExtensions
import SwinjectAutoregistration
import FrameworkProviderMocks
import InterfaceTestFactories
import FrameworkProviderTestFactories

final class LocationRepositoryTests: QuickSpec {
    override class func spec() {
        describe("LocationRepository") {
            var container: Container!
            var repository: LocationRepository!
            var errorRecorder: Recorder<LocationRepositoryError?, Never>!

            beforeEach {
                container = Container().injectRepositories()
                    .injectFrameworkProviderFacades()
                    .injectFrameworkProviderMocks()
                    .injectInterfaceLocalMocks()
                TimeAdvancingFactory(container).save()

                repository = container~>
                errorRecorder = repository.$lastError.record()
            }

            Then("location starts empty") {
                expect(repository.location).to(beNil())
            }

            Given("I request a new location") {
                var recorder: Recorder<Void, LocationRepositoryError>!
                var completion: Subscribers.Completion<LocationRepositoryError>!

                justBeforeEach {
                    recorder = repository.requestNewLocation().record()
                    container.tick()
                }

                When("I advance a second") {
                    justBeforeEach {
                        TimeAdvancingFactory(container).advance(by: MockLocationProvider.MockDelay).save()
                    }

                    When("Success") {
                        beforeEach {
                        }

                        Then("I have emitted a new location") {
                            expect(recorder.elementCount).to(equal(1))
                        }
                    }

                    When("Failure") {
                        beforeEach {
                            LocationFacadeTestFactory(container).withFailure()
                        }

                        justBeforeEach {
                            completion = waitCompletion(recorder)
                        }

                        Then("I have not emitted") {
                            expect(completion.isFailure) == true
                        }

                        Then("I have two errors") {
                            expect(errorRecorder.elementCount).to(equal(2))
                        }
                    }
                }
            }
        }
    }
}
