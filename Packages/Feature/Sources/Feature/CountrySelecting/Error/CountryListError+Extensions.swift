//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/22/22.
//

import Foundation
import DomainModels
import UIComponents
import ViewModels

extension CountryListError {
    func asFloatingAlert(viewModel: CountryListViewModel,
                         onAboutThisAppSelected: (() -> Void)?) -> FloatingAlert {
        switch self {
        case .blocked:
            return .dialog(.init(title: L10n.Errors.countryListBlockedErrorTitle, messages: [L10n.Errors.countryListBlockedErrorMessage], actionTitle: L10n.Errors.countryListBlockedErrorPositiveButton, action: {
                viewModel.navigateToRandomCountry()
            }))
        case .notEnoughPermissions:
            return .toast(.init(message: L10n.Errors.countryNotAvailableErrorMessage))
        case .other:
            return .dialog(.init(title: L10n.Errors.otherErrorTitle,
                                 messages: [L10n.Errors.otherErrorMessage1, L10n.Errors.otherErrorMessage2],
                                 actionTitle: L10n.Ui.ok,
                                 action: {
                onAboutThisAppSelected?()

            }))
        case .forbidden:
            return .dialog(.init(title: L10n.Errors.forbiddenErrorTitle, messages: [L10n.Errors.forbiddenErrorMessage]))
        case .connectionError:
            return .dialog(.init(title: L10n.Errors.connectionErrorTitle, messages: [L10n.Errors.connectionErrorMessage1, L10n.Errors.connectionErrorMessage2]))
        case .notAvailable:
            return .dialog(.init(title: L10n.Errors.genericErrorTitle, messages: [L10n.Errors.genericErrorMessage]))
        }
    }
}
