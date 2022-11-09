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
    private let uiError: CountryDetailsUIError

    public init(error: CountryDetailsUIError) {
        self.uiError = error
    }

    public var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            VStack {
                uiError.title
                    .text
                    .bold()
                    .foregroundColor(.white)
                uiError.message
                    .text
                    .foregroundColor(.white)
            }
        }.frame(maxWidth: 200, maxHeight: 200)
    }
}

struct CountryNotFoundErrorView_Previews: PreviewProvider {
    static var previews: some View {
        CountryNotFoundErrorView(error: .notFound)
    }
}

extension CountryDetailsUIError {
    var title: LocalizedString {
        L10n.Errors.countryNotFoundErrorTitle
    }
    
    var message: LocalizedString {
        L10n.Errors.countryNotFoundErrorMessage
    }
}
