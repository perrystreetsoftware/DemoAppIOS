//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import FrameworkProviderProtocols
import DomainModels
import Combine

public final class LocationProviderFacade: LocationProvidingDelegate {
    let locationProviding: LocationProviding
    
    @Published public private(set) var location: PSSLocation?
    private var mutableError = PassthroughSubject<Error, Never>()
    public lazy var error: AnyPublisher<Error, Never> = mutableError.eraseToAnyPublisher()

    init(locationProviding: LocationProviding) {
        self.locationProviding = locationProviding

        self.locationProviding.setDelegate(delegate: self)
    }

    public func didUpdateLocation(locations: [PSSLocation]) {
        locations.forEach { self.location = $0 }
    }

    public func didFailWithError(error: any Error) {
        self.mutableError.send(error)
    }

    public func startUpdatingLocation() {
        locationProviding.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationProviding.stopUpdatingLocation()
    }
}
