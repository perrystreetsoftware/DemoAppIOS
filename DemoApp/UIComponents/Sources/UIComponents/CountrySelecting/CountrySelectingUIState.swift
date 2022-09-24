//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import BusinessLogic
import DomainModels

public class CountrySelectingUIState: ObservableObject {
    @Published var error: CountrySelectingViewModelError? = nil
    @Published var continents: [Continent]
    @Published var viewModelState: CountrySelectingViewModel.State

    public convenience init(viewModel: CountrySelectingViewModel) {
        self.init(continents: viewModel.continents, state: viewModel.state)

        viewModel.$continents.dropFirst().assign(to: &$continents)
        viewModel.$state.dropFirst().assign(to: &$viewModelState)
        viewModel.events.filter { event -> Bool in
            if case .error = event {
                return true
            } else {
                return false
            }
        }
        .map({ event -> CountrySelectingViewModelError? in
            if case .error(let innerError) = event {
                return innerError
            } else {
                return nil
            }
        })
        .assign(to: &$error)
    }

    public init(continents: [Continent], state: CountrySelectingViewModel.State) {
        self.continents = continents
        self.viewModelState = state
    }
}

extension CountrySelectingUIState: Hashable {
    public static func == (lhs: CountrySelectingUIState, rhs: CountrySelectingUIState) -> Bool {
        lhs.viewModelState == rhs.viewModelState && lhs.continents == rhs.continents
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(viewModelState)
        hasher.combine(continents)
    }
}
