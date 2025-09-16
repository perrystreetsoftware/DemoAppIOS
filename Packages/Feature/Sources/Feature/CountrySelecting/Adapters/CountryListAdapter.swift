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

    public init(onCountrySelected: ((Country) -> Void)? = nil,
                onAboutThisAppSelected: (() -> Void)? = nil) {
        self.onCountrySelected = onCountrySelected
        self.onAboutThisAppSelected = onAboutThisAppSelected
    }

    public var body: some View {
        CountryListPage(listUiState: viewModel.state, onItemTapped: { country in
            viewModel.onCountrySelected(country: country)
        }, onButtonTapped: {
            viewModel.onButtonTap()
        }, onRefreshLocationTap: {
            viewModel.onRefreshLocationTap()
        }, onFailOtherTapped: {
            viewModel.onFailOtherTap()
        })
        .onReceive(viewModel.$navigationDestination, perform: { country in
            guard let country = country else { return }

            self.onCountrySelected?(country)

            viewModel.navigationDestination = nil
        })
        .pss_notify(item: $viewModel.error, alertBuilder: {
            $0.asFloatingAlert(viewModel: viewModel, onAboutThisAppSelected: onAboutThisAppSelected)
        })
    }
}
