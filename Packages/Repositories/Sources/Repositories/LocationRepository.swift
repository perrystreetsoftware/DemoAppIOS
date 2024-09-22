//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import FrameworkProviderFacades
import DomainModels
import Combine
import Interfaces
import DI

public enum LocationRepositoryError: Error {
    case timeout
    case unknown
    case facadeError(error: Error)
}

@Single
public final class LocationRepository {
    public static let LocationTimeout = TimeInterval(30)

    @Published public private(set) var location: PSSLocation?
    @Published public private(set) var state = State.idle
    @Published public private(set) var lastError: LocationRepositoryError?

    private let locationFacade: LocationProviderFacade
    private let scheduler: AppSchedulerProviding

    public enum State {
        case active
        case idle
    }

    init(locationFacade: LocationProviderFacade, scheduler: AppSchedulerProviding) {
        self.locationFacade = locationFacade
        self.scheduler = scheduler

        locationFacade.$location.assign(to: &$location)
    }

    public func requestNewLocation() -> AnyPublisher<Void, LocationRepositoryError> {
        let nextLocationPublisher: AnyPublisher<PSSLocation?, LocationRepositoryError> = self.locationFacade.$location
        // Always force it to emit a location, even if its nil, by using a sentinel value
            .map { $0 ?? PSSLocation(latitude: 0, longitude: 0) }
        // Skip the first emission, we want something fresh
            .dropFirst()
        // take first emission and close stream
            .prefix(1)
            .setFailureType(to: LocationRepositoryError.self)
            .eraseToAnyPublisher()

        let locationErrorPublisher: AnyPublisher<PSSLocation?, LocationRepositoryError> = self.locationFacade.error
            .flatMap({ (error) -> AnyPublisher<PSSLocation?, LocationRepositoryError> in
                Fail(error: LocationRepositoryError.facadeError(error: error)).eraseToAnyPublisher()
            }).prefix(untilOutputFrom: nextLocationPublisher)
            .eraseToAnyPublisher()

        return nextLocationPublisher
            .merge(with: locationErrorPublisher)
            .receive(on: scheduler.mainScheduler)
            .timeout(.seconds(Self.LocationTimeout),
                     scheduler: scheduler.mainScheduler, 
                     customError: { LocationRepositoryError.timeout })
            .handleEvents(receiveOutput: { [weak self] location in
                self?.location = location
            })
            .handleEvents(
                receiveSubscription: { [weak self] (_) in
                    guard let self = self else { return }

                    self.locationFacade.startUpdatingLocation()
                    self.state = .active
                },
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }

                    self.locationFacade.stopUpdatingLocation()

                    if case .failure(let error) = completion {
                        self.location = nil
                        self.lastError = error
                    }

                    self.state = .idle
                }, receiveCancel: { [weak self] in
                    self?.locationFacade.stopUpdatingLocation()
                    self?.state = .idle
                }
            )
            .map { _ in }
            .eraseToAnyPublisher()

    }
}
