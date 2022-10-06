//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import SwiftUI
import DomainModels
import Utils
import BusinessLogic
import UIComponents

/// Pages represent the entire thing shown onscreen. Pages take UIState objects.
/// Pages are the top-most thing that we attempt to preview.
public struct CountryDetailsPage: View {
    var state: Binding<CountryDetailsViewModel.State>
    private var onPageLoaded: (() -> Void)?

    public init(state: Binding<CountryDetailsViewModel.State>,
                onPageLoaded: (() -> Void)? = nil) {
        self.state = state
        self.onPageLoaded = onPageLoaded
    }

    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: state.map { $0.isLoading })
            CountryNotFoundErrorView(viewModelState: state)
            CountryDetailsContent(countryName: state.map { $0.countryName ?? "" }.wrappedValue,
                                  detailsText: state.map { $0.countryDetails ?? "" }.wrappedValue)
        }.onPageLoaded {
            self.onPageLoaded?()
        }
    }
}

struct CountryDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        let countryDetails = CountryDetails(country: Country(regionCode: "us"),
                                            detailsText: "Now is the time for all good men to come to the aid of their country.")

        CountryDetailsPage(state: .constant(.loaded(details: countryDetails)))
    }
}
