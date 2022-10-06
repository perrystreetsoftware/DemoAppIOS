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
import UIComponents

public struct CountrySelectingAdapter: View {
    @ObservedObject private var errorAdapter: CountrySelectingErrorAdapter
    @ObservedObject private var viewModel: CountrySelectingViewModel

    private let eventsAdapter: CountrySelectingEventsAdapter

    public init(viewModel: CountrySelectingViewModel,
                onCountrySelected: ((String) -> Void)? = nil) {
        self.viewModel = viewModel
        eventsAdapter = CountrySelectingEventsAdapter(viewModel: viewModel, onCountrySelected: onCountrySelected)
        errorAdapter = CountrySelectingErrorAdapter(viewModel: viewModel)
    }

    public var body: some View {
        CountrySelectingPage(state: $viewModel.state, onAppear: {
            viewModel.onPageLoaded()
        }, onItemTapped: { country in
            viewModel.onItemTapped(country: country)
        }) {
            viewModel.onButtonTapped()
        }.alert(item: $errorAdapter.error) { error in
            let uiError = error.uiError

            return Alert(
                title: Text(uiError.title),
                message: Text(uiError.messages.joined(separator: " ")),
                dismissButton: .cancel(Text(L10n.cancelButtonTitle), action: {
                    $errorAdapter.error.wrappedValue = nil
                })
            )
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
                onCountrySelected?(country.regionCode)
            default:
                break
            }
        }.store(in: &cancellables)
    }
}
