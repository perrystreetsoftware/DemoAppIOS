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
    @Inject var countryListViewModel: CountryListViewModel

    enum Destinations {
        case details(regionCode: String)
    }

    public init(resolver: Swinject.Resolver = InjectSettings.resolver!) {
        self.resolver = resolver
    }

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
        }
    }

    @ViewBuilder func buildBaseView() -> some View {
        CountryListAdapter(viewModel: countryListViewModel) { country in
            self.destination = Destinations.details(regionCode: country.regionCode)
        }
    }

    @ViewBuilder func buildChildViewFromState() -> some View {
        switch destination {
        case .details(let regionCode):
            let viewModel = resolver.resolve(CountryDetailsViewModel.self, argument: Country(regionCode: regionCode))!

            CountryDetailsAdapter(viewModel: viewModel)
        case .none:
            EmptyView()
        }
    }
}
