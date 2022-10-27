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

extension CountryListError {
    var uiError: UIError {
        switch self {
        case .forbidden:
            return UIError(title: L10n.Errors.forbiddenErrorTitle.stringValue, messages: [L10n.Errors.forbiddenErrorMessage.stringValue])
        default:
            return UIError(title: L10n.Errors.genericErrorTitle.stringValue, messages: [L10n.Errors.genericErrorMessage.stringValue])
        }
    }
}
