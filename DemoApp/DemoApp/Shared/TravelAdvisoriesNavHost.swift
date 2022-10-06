//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import SwiftUI
import BusinessLogic
import Utils
import Combine
import DomainModels
import Feature

public struct TravelAdvisoriesNavHost: View {
    @State var destination: Destinations?
    @Inject var builder: CountryDetailsViewModelBuilder

    enum Destinations {
        case details(regionCode: String)
    }

    public init() {
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
        CountrySelectingAdapter(viewModel: InjectSettings.resolver!.resolve(CountrySelectingViewModel.self)!) { regionCode in
            self.destination = Destinations.details(regionCode: regionCode)
        }
    }

    @ViewBuilder func buildChildViewFromState() -> some View {
        switch destination {
        case .details(let regionCode):
            let viewModel = builder.build(country: Country(regionCode: regionCode))

            CountryDetailsAdapter(viewModel: viewModel)
        case .none:
            EmptyView()
        }
    }
}
