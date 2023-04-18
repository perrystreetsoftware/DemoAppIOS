//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 08/03/23.
//

import Foundation
import SwiftUI

public struct ProTheme: ThemeImplementing {
    public struct Color: ThemeColor {
        public let accent = ColorPalette.charizard
        public let content = ColorPalette.white
        public let scheme: ColorScheme = .dark
    }
    
    public let color: ThemeColor = ProTheme.Color()
    
    public init() {}
}
