//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 08/03/23.
//

import Foundation
import SwiftUI

public struct FreeTheme: ThemeImplementing {
    public struct Color: ThemeColor {
        public let accent = ColorPalette.blastoise
        public let content = ColorPalette.black
        public let scheme: ColorScheme = .light
    }
    
    public let color: ThemeColor = FreeTheme.Color()
    
    public init() {}
}
