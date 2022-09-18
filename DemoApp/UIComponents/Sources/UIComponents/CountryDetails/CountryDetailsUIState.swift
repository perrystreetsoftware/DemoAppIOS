//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import SwiftUI
import DomainModels
import BusinessLogic

/// UIState selectively maps the @Published values of a ViewModel into the pieces necessary to
/// render the UI
public final class CountryDetailsUIState: ObservableObject {
    @Published var details: CountryDetailsUIModel?
    @Published var state: CountryDetailsViewModel.State

    public init(details: CountryDetailsUIModel?, state: CountryDetailsViewModel.State) {
        self.details = details
        self.state = state
    }

    public convenience init(viewModel: CountryDetailsViewModel) {
        self.init(details: viewModel.details, state: viewModel.state)

        viewModel.$details.assign(to: &$details)
        viewModel.$state.assign(to: &$state)
    }
}
