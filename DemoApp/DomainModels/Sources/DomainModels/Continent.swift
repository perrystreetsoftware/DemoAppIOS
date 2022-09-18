//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct Continent {
    public let name: String
    public let countries: [Country]

    public init(name: String, countries: [Country]) {
        self.name = name
        self.countries = countries
    }
}

extension Continent: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(countries)
    }
}
