//
//  ThemeImplementing.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import SwiftUI
import Foundation

public protocol ThemeImplementing {
    var name: String { get }
    var colors: Colors { get }
    var spacing: SpacingRoles { get }
    var padding: PaddingRoles { get }
    var sizing: SizingRoles { get }
}
