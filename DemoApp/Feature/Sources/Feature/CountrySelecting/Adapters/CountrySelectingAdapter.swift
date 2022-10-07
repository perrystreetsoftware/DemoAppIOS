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
import DomainModels

public struct CountrySelectingAdapter: View {
    @ObservedObject private var errorAdapter: CountrySelectingErrorAdapter
    @ObservedObject private var viewModel: CountrySelectingViewModel

    @ObservedObject private var eventsAdapter: CountrySelectingEventsAdapter

    public init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel
        eventsAdapter = CountrySelectingEventsAdapter(viewModel: viewModel)
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
        }.emitRouteEvent(value: $eventsAdapter.event)
    }
}

public class CountrySelectingEventsAdapter: ObservableObject {
    private var viewModel: CountrySelectingViewModel

    @Published var event: TravelAdvisoriesNavHostKey.Event?
    private var cancellables = Set<AnyCancellable>()

    public init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel

        viewModel.events.sink { event in
            switch event {
            case .itemTapped(let country):
                self.event = .onCountrySelected(country)
            default:
                break
            }
        }.store(in: &cancellables)
    }
}

extension View {
    @ViewBuilder
    func emitRouteEvent(value: Binding<TravelAdvisoriesNavHostKey.Event?>) -> some View {
        if let validValue = value.wrappedValue {
            preference(key: TravelAdvisoriesNavHostKey.self, value: validValue)
        } else {
            self
        }
    }
}

public struct TravelAdvisoriesNavHostKey: PreferenceKey {
    public enum Event: Equatable {
        case onCountrySelected(Country)
    }
    
    public static var defaultValue: Event? = nil
    public static func reduce(value: inout Event?, nextValue: () -> Event?) {
        value = value ?? nextValue()
    }
}
