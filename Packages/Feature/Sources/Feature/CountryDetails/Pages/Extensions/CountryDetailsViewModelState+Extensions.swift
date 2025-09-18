//
//  CountryDetailsViewModelState+Extensions.swift
//  Feature
//
//  Created by Eric Silverberg on 9/17/25.
//

import ViewModels

public extension CountryDetailsViewModel.State {
    var countryName: String {
        switch self {
        case .loaded(let details):
            return details.country.countryName ?? ""
        default:
            return ""
        }
    }

    var countryDetails: String {
        switch self {
        case .loaded(let details):
            return details.detailsText ?? ""
        default:
            return ""
        }
    }
}
