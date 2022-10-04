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
    @ObservedObject private var errorAdapter: CountrySelectingErrorAdapter
    @State var state: ListOfAllViewsWeCanReach?

    enum ListOfAllViewsWeCanReach {
        case details(regionCode: String)
    }

    public init() {
        errorAdapter = CountrySelectingErrorAdapter()
    }

    public var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: self.buildChildViewFromState(),
                    isActive: $state.mappedToBool(),
                    label: {
                        EmptyView()
                    }
                )

                self.buildBaseView()
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

    @ViewBuilder func buildBaseView() -> some View {
        CountrySelectingAdapter(viewModel: InjectSettings.resolver!.resolve(CountrySelectingViewModel.self)!) { regionCode in
            self.state = ListOfAllViewsWeCanReach.details(regionCode: regionCode)
        }
    }

    @ViewBuilder func buildChildViewFromState() -> some View {
        switch state {
        case .details(let regionCode):
            CountryDetailsAdapter(country: Country(regionCode: regionCode))
        case .none:
            EmptyView()
        }
    }
}
