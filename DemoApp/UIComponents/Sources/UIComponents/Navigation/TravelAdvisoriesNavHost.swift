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
import DomainModels

public struct TravelAdvisoriesNavHost: View {
    @ObservedObject private var navigationState: CountrySelectingNavigatorState
    @ObservedObject private var errorAdapter: CountrySelectingErrorAdapter

    public init() {
        navigationState = CountrySelectingNavigatorState()
        errorAdapter = CountrySelectingErrorAdapter()
    }

    public var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: navigationState.buildView(),
                    isActive: .constant(true),
                    label: {
                        EmptyView()
                    }
                )
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
}

public class CountrySelectingNavigatorState: ObservableObject {
    private var nextCountryToReach: String?
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var state: ListOfAllViewsWeCanReach

    enum ListOfAllViewsWeCanReach {
        case selecting
        case details
    }

    init() {
        state = .selecting
    }

    @ViewBuilder func buildView() -> some View {
        switch state {
        case .selecting:
            CountrySelectingAdapter(viewModel: InjectSettings.resolver!.resolve(CountrySelectingViewModel.self)!) { nextCountry in
                self.nextCountryToReach = nextCountry
                self.state = ListOfAllViewsWeCanReach.details
            }
        case .details:
            CountryDetailsAdapter(country: Country(regionCode: nextCountryToReach!))
        }
    }
}
