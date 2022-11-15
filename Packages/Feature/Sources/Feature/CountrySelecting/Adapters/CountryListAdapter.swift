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
    @ObservedObject private var viewModel: CountryListViewModel

    private var onCountrySelected: ((Country) -> Void)?

    public init(viewModel: CountryListViewModel,
                onCountrySelected: ((Country) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onCountrySelected = onCountrySelected
    }

    public var body: some View {
        CountryListPage(listUiState: viewModel.state, onItemTapped: { country in
            onCountrySelected?(country)
        }) {
            viewModel.onButtonTapped()
        }
        .alert(item: $viewModel.error) { error in
            return Alert(countryListError: error)
        }
    }
}
