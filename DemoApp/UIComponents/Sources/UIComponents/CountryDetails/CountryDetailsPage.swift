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
    private var onFirstAppear: (() -> Void)?

    public init(state: CountryDetailsUIState,
                onFirstAppear: (() -> Void)? = nil) {
        self.state = state
        self.onFirstAppear = onFirstAppear
    }

    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: $state.state.map { $0.isLoading })
            CountryDetailsContent(countryName: state.details?.countryName ?? "",
                                  detailsText: state.details?.detailsText ?? "")
        }.onFirstAppear {
            self.onFirstAppear?()
        }
    }
}

struct CountryDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailsPage(state: CountryDetailsUIState(details: CountryDetailsUIModel(regionCode: "us", detailsText: "Now is the time for all good men to come to the aid of their country."), state: .loading))
    }
}
