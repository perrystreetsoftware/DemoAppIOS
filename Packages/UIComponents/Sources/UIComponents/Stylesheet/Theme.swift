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
public struct Theme: DynamicProperty {

    @StateObject private var stylesheet: Stylesheet

    public init() {
        _stylesheet = .init(wrappedValue: Stylesheet.shared)
    }

    public var wrappedValue: ThemeImplementing {
        get { return stylesheet.currentTheme }
    }
}
