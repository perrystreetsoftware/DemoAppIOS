//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 09/03/23.
//

import Foundation
import DomainModels
import ViewModels
import SwiftUI
import Utils

public struct ThemeKey: EnvironmentKey {
    public static var defaultValue: ThemeImplementing = InjectSettings.resolver!.resolve(Stylesheet.self)!.currentTheme
}

public extension EnvironmentValues {
    var theme: ThemeImplementing {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
