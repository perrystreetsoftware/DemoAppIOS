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
    case userNotLoggedIn

    public static func == (lhs: CountryListError, rhs: CountryListError) -> Bool {
        switch (lhs, rhs) {
        case (.connectionError, .connectionError):
            return true
        case (.forbidden, .forbidden):
            return true
        case (.other, .other):
            return true
        case (.userNotLoggedIn, .userNotLoggedIn):
            return true
        default:
            return false
        }
    }
}

// Necessary to be renderable in SwiftUI
extension CountryListError: Identifiable {
    public var id: Int {
        switch self {
        case .forbidden:
            return 0
        case .connectionError:
            return 1
        case .other:
            return 2
        case .userNotLoggedIn:
            return 3
        }
    }
}
