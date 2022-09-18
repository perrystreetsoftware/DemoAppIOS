//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation

public struct CountryDetailsDTO: Codable {
    public let area: String
    public let regionName: String
    public let regionCode: String
    public let legalCodeBody: String

    public init(area: String,
                regionName: String,
                regionCode: String,
                legalCodeBody: String) {
        self.area = area
        self.regionName = regionName
        self.regionCode = regionCode
        self.legalCodeBody = legalCodeBody
    }

    enum CodingKeys: String, CodingKey {
        case area
        case regionName
        case regionCode = "iso2"
        case legalCodeBody
    }
}
