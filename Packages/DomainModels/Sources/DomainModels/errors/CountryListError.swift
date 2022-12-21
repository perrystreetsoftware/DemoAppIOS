//
//  File.swift
//  
//
//  Created by Eric Silverberg on 10/27/22.
//

import Foundation

public enum CountryListError: Error, Equatable {
    case forbidden
    case connectionError(innerError: Error?)
    case other

    case notEnoughPermissions
    case notAvailable
    case blocked

    public static func == (lhs: CountryListError, rhs: CountryListError) -> Bool {
        switch (lhs, rhs) {
        case (.connectionError, .connectionError):
            return true
        case (.forbidden, .forbidden):
            return true
        case (.other, .other):
            return true
        case (.notEnoughPermissions, .notEnoughPermissions):
            return true
        case (.notAvailable, .notAvailable):
            return true
        case (.blocked, .blocked):
            return true
        default:
            return false
        }
    }
}

// Necessary to be renderable in SwiftUI
extension CountryListError: Identifiable {
    public var id: String { String(describing: self) }
}
