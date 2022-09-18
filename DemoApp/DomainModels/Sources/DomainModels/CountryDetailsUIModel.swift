//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct CountryDetailsUIModel {
    public let countryName: String?
    public let regionCode: String
    public let detailsText: String

    public init(regionCode: String, detailsText: String) {
        self.countryName = Locale.current.localizedString(forRegionCode: regionCode)
        self.regionCode = regionCode
        self.detailsText = detailsText
    }

    public init(countryDetailsDTO: CountryDetailsDTO) {
        self.init(regionCode: countryDetailsDTO.regionCode, detailsText: countryDetailsDTO.legalCodeBody)
    }
}


extension CountryDetailsUIModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(countryName ?? "")
        hasher.combine(regionCode)
        hasher.combine(detailsText)
    }
}
