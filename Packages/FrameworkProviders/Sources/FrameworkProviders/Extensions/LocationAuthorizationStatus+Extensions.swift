//
//  LocationAuthorizationStatus+Extensions.swift
//  FrameworkProviders
//
//  Created by Eric Silverberg on 9/15/25.
//

import CoreLocation
import FrameworkProviderProtocolModels

extension LocationAuthorizationStatus {
    init(_ location: CLAuthorizationStatus) {
        switch location {
        case .authorizedAlways:
            self = .authorizedAlways
        case .notDetermined:
            self = .notDetermined
        case .denied:
            self = .denied
        case .authorizedWhenInUse:
            self = .authorizedWhenInUse
        case .restricted:
            self = .restricted
        case .authorized:
            self = .authorizedAlways
        default:
            self = .notDetermined
        }
    }
}
