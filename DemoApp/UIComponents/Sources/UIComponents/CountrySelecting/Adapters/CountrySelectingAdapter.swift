//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import SwiftUI
import BusinessLogic
import Utils
import Combine

public struct CountrySelectingAdapter: View {
    @ObservedObject private var viewModel: CountrySelectingViewModel
    private let eventsAdapter: CountrySelectingEventsAdapter

    public init(viewModel: CountrySelectingViewModel,
                onCountrySelected: ((String) -> Void)? = nil) {
        self.viewModel = viewModel
        eventsAdapter = CountrySelectingEventsAdapter(viewModel: viewModel, onCountrySelected: onCountrySelected)
    }

    public var body: some View {
        CountrySelectingPage(state: $viewModel.state, onAppear: {
            viewModel.onPageLoaded()
        }, onItemTapped: { country in
            viewModel.onItemTapped(country: country)
        }) {
            viewModel.onButtonTapped()
        }
    }
}

public class CountrySelectingEventsAdapter: ObservableObject {
    private var viewModel: CountrySelectingViewModel
    private let onCountrySelected: ((String) -> Void)?

    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: CountrySelectingViewModel,
                onCountrySelected: ((String) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onCountrySelected = onCountrySelected

        viewModel.events.sink { event in
            switch event {
            case .itemTapped(let country):
                if let countryName = country.countryName {
                    onCountrySelected?(countryName)
                }
            default:
                break
            }
        }.store(in: &cancellables)
    }
}
