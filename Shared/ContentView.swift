//
//  ContentView.swift
//  Shared
//
//  Created by Eric Silverberg on 9/10/22.
//

import SwiftUI
import UIComponents
import Utils
import ViewModels

struct ContentView: View {
    
    @InjectStateObject private var themeViewModel: AppThemeViewModel
    @State private var theme: Theme = ProTheme()
    
    init() {
        self._theme = .init(wrappedValue:  ThemeFactory.build(theme: themeViewModel.currentTheme))
    }
    
    var body: some View {
        TravelAdvisoriesNavHost()
            .accentColor(theme.color.accent)
            .foregroundColor(theme.color.content)
            .preferredColorScheme(theme.color.scheme)
            .environment(\.theme, theme)
            .onChange(of: themeViewModel.currentTheme) { newValue in
                self.theme = ThemeFactory.build(theme: newValue)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
