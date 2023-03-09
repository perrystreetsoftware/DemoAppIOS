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

@propertyWrapper
public struct InjectTheme: DynamicProperty {

    @InjectStateObject private var themeViewModel: AppThemeViewModel

    public init() {}

    public var wrappedValue: Theme {
        get { return ThemeFactory.build(theme: themeViewModel.currentTheme) }
    }
}
