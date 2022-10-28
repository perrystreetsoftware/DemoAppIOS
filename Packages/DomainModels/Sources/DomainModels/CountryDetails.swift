//
//  CountryDetails.swift
//
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct CountryDetails: Equatable {
    public let country: Country
    public let detailsText: String?

    public init(country: Country, detailsText: String?) {
        self.country = country
        self.detailsText = detailsText
    }
}


extension CountryDetails: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(country.regionCode)
        hasher.combine(detailsText)
    }
}
