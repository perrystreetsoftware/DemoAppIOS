//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct ContinentUIModel {
    public let name: String
    public let countries: [CountryUIModel]

    public init(name: String, countries: [CountryUIModel]) {
        self.name = name
        self.countries = countries
    }
}

extension ContinentUIModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(countries)
    }
}
