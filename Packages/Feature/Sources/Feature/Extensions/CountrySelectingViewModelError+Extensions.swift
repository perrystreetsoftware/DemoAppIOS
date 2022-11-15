//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/24/22.
//

import Foundation
import UIComponents
import ViewModels
import DomainModels
import SwiftUI

extension Alert {
    init(countryListError error: CountryListError) {
        switch error {
        case .forbidden:
            self.init(
                title: Text(L10n.Errors.forbiddenErrorTitle.stringValue),
                message: Text(L10n.Errors.forbiddenErrorMessage.stringValue),
                dismissButton: .cancel(L10n.Ui.cancelButtonTitle.text)
            )
        case .connectionError, .other, .userNotLoggedIn:
            self.init(
                title: Text(L10n.Errors.genericErrorTitle.stringValue),
                message: Text(L10n.Errors.genericErrorMessage.stringValue),
                dismissButton: .cancel(L10n.Ui.cancelButtonTitle.text)
            )
        }
    }
}
