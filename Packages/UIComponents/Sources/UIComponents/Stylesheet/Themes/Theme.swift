//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 08/03/23.
//

import Foundation
import SwiftUI
import DomainModels

public protocol Theme {
    var color: ThemeColor { get }
}

public protocol ThemeColor {
    var accent: Color { get }
    var content: Color { get }
    var scheme: ColorScheme { get }
}

public struct ThemeFactory {
    public static func build(theme: AppTheme) -> Theme {
        switch theme {
        case .free:
            return FreeTheme()
        case .pro:
            return ProTheme()
        }
    }
}
