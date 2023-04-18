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
    var theme: ThemeImplementing
    
    public func body(content: Content) -> some View {
        content
            .accentColor(theme.color.accent)
            .foregroundColor(theme.color.content)
            .preferredColorScheme(theme.color.scheme)
            .environment(\.theme, theme)
    }
}

public extension View {
    func theme(_ theme: ThemeImplementing) -> some View {
        self.modifier(ThemeModifier(theme: theme))
    }
}
