//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 08/03/23.
//

import Foundation
import SwiftUI

public struct FreeTheme: Theme {
    public struct Color: ThemeColor {
        public let accent = ColorPalette.freeAccent
        public let content = ColorPalette.black
        public let scheme: ColorScheme = .light
    }
    
    public let color: ThemeColor = FreeTheme.Color()
    
    public init() {}
}
