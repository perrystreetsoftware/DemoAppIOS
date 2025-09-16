//
//  LocationUiState.swift
//  ViewModels
//
//  Created by Eric Silverberg on 9/15/25.
//

import FrameworkProviderProtocolModels

public enum LocationUiState: Equatable {
    case unknown
    case updating
    case error
    case location(PSSLocation)
}

extension LocationUiState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .updating:
            return "updating"
        case .error:
            return "error"
        case .location(let location):
            return "location:\(location.latitude),\(location.longitude)"
        }
    }
}
