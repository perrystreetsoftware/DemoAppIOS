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

public struct TravelAdvisoriesNavHost: View {
    private let resolver: Swinject.Resolver

    @State var destination: Destinations?

    enum Destinations {
        case details(regionCode: String)
        case aboutThisApp
    }

    public init(resolver: Swinject.Resolver = InjectSettings.resolver!) {
        self.resolver = resolver
    }

    public var body: some View {
        TabView {
           HomeTab().tabItem {
                Label("Home", systemImage: "house")
            }
            
            FlagsTab().tabItem {
                Label("Latin America Flags", systemImage: "flag")
            }
        }
    }

    @ViewBuilder func HomeTab() -> some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: self.buildChildViewFromState(),
                    isActive: $destination.mappedToBool(),
                    label: {
                        EmptyView()
                    }
                )
                
                CountryListAdapter(onCountrySelected: { country in
                    self.destination = Destinations.details(regionCode: country.regionCode)
                }) {
                    self.destination = Destinations.aboutThisApp
                }
            }
        }
    }
    
    @ViewBuilder func FlagsTab() -> some View {
        NavigationView {
            LatinAmericaFlagsAdapter()
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
