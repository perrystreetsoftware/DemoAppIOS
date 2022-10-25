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
import BusinessLogic
import ViewModels

/// Content is a component of a page. Content accepts bindings or simple primitive types.
public struct CountryNotFoundErrorView: View {
    private let viewModelState: Binding<CountryDetailsViewModel.State>

    public init(viewModelState: Binding<CountryDetailsViewModel.State>) {
        self.viewModelState = viewModelState
    }

    public var body: some View {
        switch viewModelState.wrappedValue {
        case .error(let error):
            if case .countryNotFound = error {
                ZStack {
                    Color.red
                        .ignoresSafeArea()

                    VStack {
                        Text("Error")
                            .bold()
                            .foregroundColor(.white)
                        Text("Country not found")
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
        CountryNotFoundErrorView(viewModelState: .constant(.error(error: .countryNotFound)))
    }
}
