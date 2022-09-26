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
    private let viewModel: CountrySelectingViewModel
    @ObservedObject private var navigatorAdapter: CountrySelectingNavigatorAdapter
    @ObservedObject private var errorAdapter: CountrySelectingErrorAdapter

    public init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel
        navigatorAdapter = CountrySelectingNavigatorAdapter(viewModel: viewModel)
        errorAdapter = CountrySelectingErrorAdapter(viewModel: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: navigatorAdapter.buildView(),
                    isActive: $navigatorAdapter.nextCountryToReach.mappedToBool(),
                    label: {
                        EmptyView()
                    }
                )

                CountrySelectingPage(state: CountrySelectingUIState(viewModel: viewModel), onAppear: {
                    viewModel.onPageLoaded()
                }, onItemTapped: { country in
                    viewModel.onItemTapped(country: country)
                }) {
                    viewModel.onButtonTapped()
                }
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
