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
    
    @InjectTheme private var theme: Theme
    
    var body: some View {
        TravelAdvisoriesNavHost()
            .accentColor(theme.color.accent)
            .foregroundColor(theme.color.content)
            .preferredColorScheme(theme.color.scheme)
            .environment(\.theme, theme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
