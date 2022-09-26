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

/// Pages represent the entire thing shown onscreen. Pages take UIState objects.
/// Pages are the top-most thing that we attempt to preview.
public struct CountryDetailsPage: View {
    @ObservedObject var state: CountryDetailsUIState
    private var onPageLoaded: (() -> Void)?

    public init(state: CountryDetailsUIState,
                onPageLoaded: (() -> Void)? = nil) {
        self.state = state
        self.onPageLoaded = onPageLoaded
    }

    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: $state.viewModelState.map { $0.isLoading })
            CountryNotFoundErrorView(viewModelState: $state.viewModelState)
            CountryDetailsContent(countryName: state.details?.country.countryName ?? "",
                                  detailsText: state.details?.detailsText ?? "")
        }.onPageLoaded {
            self.onPageLoaded?()
        }
    }
}

struct CountryDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailsPage(state: CountryDetailsUIState(details: CountryDetails(country: Country(regionCode: "us"),
                                                                                detailsText: "Now is the time for all good men to come to the aid of their country."), state: .loading))
    }
}
