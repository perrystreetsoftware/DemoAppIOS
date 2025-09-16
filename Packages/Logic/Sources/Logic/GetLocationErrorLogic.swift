//
//  GetLocationErrorLogic.swift
//  Logic
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Repositories
import Combine
import DI
import DomainModels

@Factory
public final class GetLocationErrorLogic {
    private let locationRepository: LocationRepository

    public func callAsFunction() -> AnyPublisher<LocationLogicError?, Never> {
        locationRepository.$lastError.eraseToAnyPublisher()
    }
}
