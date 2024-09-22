//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import Repositories
import DI
import Combine

@Factory
public final class RequestNewLocationLogic {
    private let locationRepository: LocationRepository

    public func callAsFunction() -> AnyPublisher<Void, LocationRepositoryError> {
        locationRepository.requestNewLocation()
    }
}
