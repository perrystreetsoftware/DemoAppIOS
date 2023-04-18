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
    
    @Environment(\.theme) private var theme: ThemeImplementing
    
    var body: some View {
        TravelAdvisoriesNavHost()
    }
}
