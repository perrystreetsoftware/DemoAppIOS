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
import UIComponents
import ViewModels

/// Pages represent the entire thing shown onscreen. Pages take UIState objects.
/// Pages are the top-most thing that we attempt to preview.
public struct CountryDetailsPage: View {
    var detailsUiState: CountryDetailsViewModel.State

    public init(detailsUiState: CountryDetailsViewModel.State) {
        self.detailsUiState = detailsUiState
    }

    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: detailsUiState.isLoading)
            CountryNotFoundErrorView(viewModelState: detailsUiState)
            CountryDetailsContent(countryName: detailsUiState.countryName,
                                  detailsText: detailsUiState.countryDetails)
        }
    }
}

struct CountryDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        let countryDetails = CountryDetails(country: Country(regionCode: "us"),
                                            detailsText: "Now is the time for all good men to come to the aid of their country.")

        CountryDetailsPage(detailsUiState: .loaded(details: countryDetails))
    }
}
