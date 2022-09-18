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

public class CountrySelectingViewNavigator: ObservableObject {
    @Published var nextViewToReach: AnyView?
    private var viewModel: CountrySelectingViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel

        viewModel.events.sink { event in
            switch event {
            case .itemTapped(let country):
                self.nextViewToReach = AnyView(CountryDetailsAdapter(country: country))
            }
        }.store(in: &cancellables)
    }
}
