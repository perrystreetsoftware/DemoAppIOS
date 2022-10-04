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
    enum ListOfAllViewsWeCanReach {
        case selecting
        case details(regionCode: String)

        var isRootView: Bool {
            switch self {
            case .selecting:
                return true
            default:
                return false
            }
        }
    }

    @State private var state: ListOfAllViewsWeCanReach = .selecting
    @ObservedObject private var errorAdapter: CountrySelectingErrorAdapter

    public init() {
        errorAdapter = CountrySelectingErrorAdapter()
    }

    public var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: buildView(),
                    isActive: $state.map { $0.isRootView == false },
                    label: {
                        EmptyView()
                    }
                )

                buildView()
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

    @ViewBuilder func buildView() -> some View {
        switch state {
        case .selecting:
            CountrySelectingAdapter(viewModel: InjectSettings.resolver!.resolve(CountrySelectingViewModel.self)!) { regionCode in
                self.state = ListOfAllViewsWeCanReach.details(regionCode: regionCode)
            }
        case .details(let regionCode):
            CountryDetailsAdapter(country: Country(regionCode: regionCode))
        }
    }
}
