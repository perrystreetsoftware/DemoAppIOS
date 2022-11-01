import Combine
import DomainModels
import Foundation
import Interfaces

@testable import Repositories

extension CountryDetailsDTO {
    static func fixture(
        area: String = "",
        regionName: String = "",
        regionCode: String = "",
        legalCodeBody: String? = nil
    ) -> Self {
        .init(
            area: area,
            regionName: regionName,
            regionCode: regionCode,
            legalCodeBody: legalCodeBody
        )
    }
}

extension CountryDetails {
    static func fixture(
        country: Country = .fixture(),
        detailsText: String? = nil
    ) -> Self {
        .init(
            country: country,
            detailsText: detailsText
        )
    }
}

extension Country {
    static func fixture(regionCode: String = "") -> Self {
        .init(
            regionCode: regionCode
        )
    }
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case .finished:
            return nil
        case .failure(let resultError):
            return resultError
        }
    }
}
