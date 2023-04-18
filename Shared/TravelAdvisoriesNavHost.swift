//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import SwiftUI
import Utils
import Combine
import DomainModels
import Feature
import ViewModels
import Swinject
import UIComponents

public struct TravelAdvisoriesNavHost: View {
    
    enum Destinations {
        case details(regionCode: String)
        case aboutThisApp
    }

    @Environment(\.theme) private var theme: ThemeImplementing
    @InjectStateObject private var themeViewModel: AppThemeViewModel
    @State var destination: Destinations?

    public init() {}

    public var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: self.buildChildViewFromState(),
                    isActive: $destination.mappedToBool(),
                    label: {
                        EmptyView()
                    }
                )

                self.buildBaseView()
            }
            .toolbar {
                Button {
                    themeViewModel.toggleTheme()
                } label: {
                    Text("Change theme")
                        .foregroundColor(theme.color.accent)
                }
            }
        }
    }

    @ViewBuilder func buildBaseView() -> some View {
        CountryListAdapter(onCountrySelected: { country in
            self.destination = Destinations.details(regionCode: country.regionCode)
        }) {
            self.destination = Destinations.aboutThisApp
        }
    }

    @ViewBuilder func buildChildViewFromState() -> some View {
        switch destination {
        case .details(let regionCode):
            CountryDetailsAdapter(regionCode: regionCode)
        case .aboutThisApp:
            AboutAdapter()
        case .none:
            EmptyView()
        }
    }
}
