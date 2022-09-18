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
    @Published var continents: [ContinentUIModel]
    @Published var state: CountrySelectingViewModel.State

    public convenience init(viewModel: CountrySelectingViewModel) {
        self.init(continents: viewModel.continents, state: viewModel.state)

        viewModel.$continents.dropFirst().assign(to: &$continents)
        viewModel.$state.dropFirst().assign(to: &$state)
    }

    public init(continents: [ContinentUIModel], state: CountrySelectingViewModel.State) {
        self.continents = continents
        self.state = state
    }
}

extension CountrySelectingUIState: Hashable {
    public static func == (lhs: CountrySelectingUIState, rhs: CountrySelectingUIState) -> Bool {
        lhs.state == rhs.state && lhs.continents == rhs.continents
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(state)
        hasher.combine(continents)
    }
}
