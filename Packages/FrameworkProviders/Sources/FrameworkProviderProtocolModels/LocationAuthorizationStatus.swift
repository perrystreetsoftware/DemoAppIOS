//
//  LocationAuthorizationStatus.swift
//  FrameworkProviders
//
//  Created by Eric Silverberg on 9/15/25.
//

public enum LocationAuthorizationStatus: Int {
    case notDetermined = 0
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse

    public var statusDescription: String {
        var statusDescription: String
        switch self {
        case .authorizedAlways:
            statusDescription = "authorized_always"
        case .notDetermined:
            statusDescription = "not_determined"
        case .denied:
            statusDescription = "denied"
        case .authorizedWhenInUse:
            statusDescription = "when_in_use"
        case .restricted:
            statusDescription = "restricted"
        }

        return statusDescription
    }

    public var isGranted: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        }
    }
}
