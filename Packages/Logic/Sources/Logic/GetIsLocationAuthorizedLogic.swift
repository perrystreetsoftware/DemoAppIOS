//
//  GetIsLocationAuthorizedLogic.swift
//  Logic
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Repositories
import Combine
import DI
import FrameworkProviderProtocolModels

@Factory
public final class GetIsLocationAuthorizedLogic {
    private let locationRepository: LocationRepository

    public func callAsFunction() -> AnyPublisher<LocationAuthorizationStatus?, LocationLogicError> {
        locationRepository.requestAuthorization()
    }
}

