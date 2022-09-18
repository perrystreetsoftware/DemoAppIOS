//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation

public struct CountryListDTO: Codable {
    public let africa: [String]
    public let asia: [String]
    public let latam: [String]
    public let oceania: [String]
    public let europe: [String]


    public init(africa: [String]? = nil,
                asia: [String]? = nil,
                latam: [String]? = nil,
                oceania: [String]? = nil,
                europe: [String]? = nil
    ) {
        self.africa = africa ?? []
        self.asia = asia ?? []
        self.latam = latam ?? []
        self.oceania = oceania ?? []
        self.europe = europe ?? []
    }

    enum CodingKeys: String, CodingKey {
        case africa
        case asia
        case latam = "latin-america-caribbean"
        case oceania
        case europe
    }
}
