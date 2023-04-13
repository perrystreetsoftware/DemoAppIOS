//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import SwiftUI
import DomainModels
import Utils
import ViewModels
import UIComponents

/// Content is a component of a page. Content accepts bindings or simple primitive types.
public struct CountryNotFoundErrorView: View {
    private let viewModelState: CountryDetailsViewModel.State

    public init(viewModelState: CountryDetailsViewModel.State) {
        self.viewModelState = viewModelState
    }

    public var body: some View {
        switch viewModelState {
        case .error(let error):
            if case .countryNotFound = error {
                ZStack {
                    Color.red
                        .ignoresSafeArea()

                    VStack {
                        L10n.Errors.countryNotFoundErrorTitle.text
                            .bold()
                            .foregroundColor(.white)
                        L10n.Errors.countryNotFoundErrorMessage.text
                            .foregroundColor(.white)
                    }
                }.frame(maxWidth: 200, maxHeight: 200)
            } else {
                Spacer().hidden()
            }
        default:
            EmptyView().hidden()
        }
    }
}

struct CountryNotFoundErrorView_Previews: PreviewProvider {
    static var previews: some View {
        CountryNotFoundErrorView(viewModelState: .error(error: .countryNotFound))
            .theme(ProTheme())
    }
}
