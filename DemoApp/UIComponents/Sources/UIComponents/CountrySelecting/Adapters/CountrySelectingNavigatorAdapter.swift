//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/22.
//

import Foundation
import Combine
import BusinessLogic
import SwiftUI
import DomainModels

public class CountrySelectingNavigatorAdapter: ObservableObject {
    @Published var nextCountryToReach: Country?
    private var viewModel: CountrySelectingViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel

        viewModel.events.sink { event in
            switch event {
            case .itemTapped(let country):
                self.nextCountryToReach = country
            case .error:
                break
            }
        }.store(in: &cancellables)
    }

    @ViewBuilder func buildView() -> some View {
        if let nextCountryToReach = nextCountryToReach {
            CountryDetailsAdapter(country: nextCountryToReach)
        } else {
            EmptyView()
        }
    }
}
