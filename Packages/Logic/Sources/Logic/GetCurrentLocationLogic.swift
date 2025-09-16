//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import Repositories
import Combine
import DI
import FrameworkProviderProtocolModels

@Factory
public final class GetCurrentLocationLogic {
    private let locationRepository: LocationRepository

    public func callAsFunction() -> AnyPublisher<PSSLocation, Never> {
        locationRepository.$location.compactMap { $0 }.eraseToAnyPublisher()
    }
}
