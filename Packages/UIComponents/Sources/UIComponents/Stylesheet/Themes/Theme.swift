//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 08/03/23.
//

import Foundation
import SwiftUI

public protocol Theme {
    var color: ThemeColor { get }
}

public protocol ThemeColor {
    var accent: Color { get }
    var content: Color { get }
    var scheme: ColorScheme { get }
}
