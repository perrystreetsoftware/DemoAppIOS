//
//  CountryDetails.swift
//
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct CountryDetails {
    public let country: Country
    public let detailsText: String?

    public init(country: Country, detailsText: String?) {
        self.country = country
        self.detailsText = detailsText
    }

    public init(countryDetailsDTO: CountryDetailsDTO) {
        self.init(country: Country(regionCode: countryDetailsDTO.regionCode),
                  detailsText: countryDetailsDTO.legalCodeBody)
    }
}


extension CountryDetails: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(country.regionCode)
        hasher.combine(detailsText)
    }
}
