//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct Country {
    public let countryName: String?
    public let regionCode: String

    public init(regionCode: String) {
        self.countryName = Locale.current.localizedString(forRegionCode: regionCode)
        self.regionCode = regionCode
    }
}

extension Country: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(countryName ?? "")
    }
}
