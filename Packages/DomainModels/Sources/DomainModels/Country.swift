//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation

public struct Country: Equatable {
    public let regionCode: String

    public init(regionCode: String) {
        self.regionCode = regionCode
    }

    public var countryName: String? {
        return Locale.current.localizedString(forRegionCode: regionCode) ?? regionCode
    }
}

extension Country: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(regionCode)
    }
}
