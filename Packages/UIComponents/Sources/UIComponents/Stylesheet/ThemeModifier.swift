//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 24/03/23.
//

import Foundation
import SwiftUI
import Utils

public struct ThemeModifier: ViewModifier {
    @InjectStateObject  var styleSheet: Stylesheet
    
    var theme: ThemeImplementing {
        styleSheet.currentTheme
    }
    
    public func body(content: Content) -> some View {
        content
            .accentColor(styleSheet.currentTheme.color.accent)
            .foregroundColor(styleSheet.currentTheme.color.content)
            .preferredColorScheme(styleSheet.currentTheme.color.scheme)
            .environment(\.theme, styleSheet.currentTheme)
    }
}

public extension View {
    func themed() -> some View {
        self.modifier(ThemeModifier())
    }
}
