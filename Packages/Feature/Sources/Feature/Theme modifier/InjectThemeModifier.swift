//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 13/04/23.
//

import Foundation
import SwiftUI
import Utils
import UIComponents

/// Injects the theme into the view environment
///
/// The use of this modifier is intended for view adapters to avoid
///  using DI on previews
public struct InjectThemeModifier: ViewModifier {
    @InjectStateObject var styleSheet: Stylesheet
    
    var theme: ThemeImplementing {
        styleSheet.currentTheme
    }
    
    public func body(content: Content) -> some View {
        content.theme(theme)
    }
}

public extension View {
    func themeInjected() -> some View {
        self.modifier(InjectThemeModifier())
    }
}
