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
    @ObservedObject private var viewModel: CountrySelectingViewModel

    private var onCountrySelected: ((Country) -> Void)?

    public init(viewModel: CountrySelectingViewModel,
                onCountrySelected: ((Country) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onCountrySelected = onCountrySelected
    }

    public var body: some View {
        CountrySelectingPage(state: $viewModel.state, onAppear: {
            viewModel.onPageLoaded()
        }, onItemTapped: { country in
            onCountrySelected?(country)
        }) {
            viewModel.onButtonTapped()
        }.alert(item: $viewModel.error) { error in
            let uiError = error.uiError

            return Alert(
                title: Text(uiError.title),
                message: Text(uiError.messages.joined(separator: " ")),
                dismissButton: .cancel(Text(L10n.cancelButtonTitle), action: {
                    $viewModel.error.wrappedValue = nil
                })
            )
        }
    }
}
