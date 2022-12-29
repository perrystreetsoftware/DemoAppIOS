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
import UIComponents
import DomainModels
import ViewModels

public struct CountryListAdapter: View {
    @InjectStateObject private var viewModel: CountryListViewModel

    private var onCountrySelected: ((Country) -> Void)?
    private var onAboutThisAppSelected: (() -> Void)?
    @Binding var destination: Destinations?

    public init(destination: Binding<Destinations?>) {
        self._destination = destination
    }

    public var body: some View {
        CountryListPage(listUiState: viewModel.state, onItemTapped: { country in
            viewModel.onCountrySelected(country: country)
        }, onButtonTapped: {
            viewModel.onButtonTapped()
        }, onFailOtherTapped: {
            viewModel.onFailOtherTapped()
        })
        .onReceive(viewModel.$navigationDestination, perform: { country in
            guard let country = country else { return }

            self.destination = Destinations.details(regionCode: country.regionCode)
        })
        .onReceive(Just($destination), perform: { newValue in
            if newValue.wrappedValue == nil && viewModel.navigationDestination != nil {
                viewModel.navigationDestination = nil
            }
        })
        .pss_notify(item: $viewModel.error, alertBuilder: {
            $0.asFloatingAlert(viewModel: viewModel, onAboutThisAppSelected: {
                self.destination = Destinations.aboutThisApp
            })
        })
    }
}
