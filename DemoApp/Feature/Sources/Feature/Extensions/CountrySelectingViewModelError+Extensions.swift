//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/24/22.
//

import Foundation
import UIComponents
import ViewModels

extension CountrySelectingViewModelError {
    var uiError: UIError {
        switch self {
        case .forbidden:
            return UIError(title: L10n.forbiddenErrorTitle, messages: [L10n.forbiddenErrorMessage])
        default:
            return UIError(title: L10n.genericErrorTitle, messages: [L10n.genericErrorMessage])
        }
    }
}
