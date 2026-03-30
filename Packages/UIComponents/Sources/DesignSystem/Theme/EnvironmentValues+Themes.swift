//
//  EnvironmentValues+Themes.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import Foundation
import SwiftUI

public extension EnvironmentValues {
    var theme: ThemeImplementing {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

public struct ThemeKey: EnvironmentKey {
    public static var defaultValue: ThemeImplementing = AppTheme()
}
