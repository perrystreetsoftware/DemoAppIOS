//
//  File.swift
//  
//
//  Created by Stelios Frantzeskakis on 16/10/24.
//

import Foundation
import ViewModels
import DomainModels

class CountryListContext: ObservableObject {
    @Published var listUiState: CountryListViewModel.UiState
    var onCountrySelected: ((Country) -> Void)?
    var onButtonTapped: (() -> Void)?
    var onFailOtherTapped: (() -> Void)?
    
    init(listUiState: CountryListViewModel.UiState,
         onCountrySelected: ((Country) -> Void)? = nil,
         onButtonTapped: (() -> Void)? = nil,
         onFailOtherTapped: (() -> Void)? = nil) {
        self.listUiState = listUiState
        self.onCountrySelected = onCountrySelected
        self.onButtonTapped = onButtonTapped
        self.onFailOtherTapped = onFailOtherTapped
    }
}
