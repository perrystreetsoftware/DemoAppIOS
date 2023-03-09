//
//  ContentView.swift
//  Shared
//
//  Created by Eric Silverberg on 9/10/22.
//

import SwiftUI
import UIComponents
import Utils

struct ContentView: View {
    @State private var theme: Theme = FreeTheme()
    
    var body: some View {
        TravelAdvisoriesNavHost()
            .accentColor(theme.color.accent)
            .foregroundColor(theme.color.content)
            .preferredColorScheme(theme.color.scheme)
            .environment(\.theme, theme)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    self.theme = ProTheme()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
