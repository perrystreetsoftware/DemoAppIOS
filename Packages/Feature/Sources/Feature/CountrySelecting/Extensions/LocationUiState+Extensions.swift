//
//  LocationUiState+Extensions.swift
//  Feature
//
//  Created by Eric Silverberg on 9/15/25.
//

import ViewModels
import DomainModels
import UIComponents

extension LocationUiState {
    var uiString: LocalizedString {
        switch self {
        case .unknown:
            return L10n.Ui.locationStateUnknown
        case .error:
            return L10n.Ui.locationStateError
        case .location(let yourLocation):
            return L10n.Ui.locationStateYourLocation(yourLocation.uiString)
        case .updating:
            return L10n.Ui.locationStateUpdating
        }
    }
}
