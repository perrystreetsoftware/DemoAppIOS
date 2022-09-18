//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Interfaces
import DomainModels
import Combine

public enum CountryDetailsRepositoryError: Error, Equatable {
    case apiError(innerError: TravelAdvisoryApiError)
    case other

    public static func == (lhs: CountryDetailsRepositoryError, rhs: CountryDetailsRepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.other, .other):
            return true
        case (.apiError(let innerError1), .apiError(let innerError2)):
            return innerError1 == innerError2
        default:
            return false
        }
    }
}

public class CountryDetailsRepository {
    private let countryListProviding: TravelAdvisoryApiImplementing

    public init(countryListProviding: TravelAdvisoryApiImplementing) {
        self.countryListProviding = countryListProviding
    }

    public func getDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, CountryDetailsRepositoryError> {
        return countryListProviding.getCountryDetails(regionCode: regionCode)
            .mapError { .apiError(innerError: $0) }
        .eraseToAnyPublisher()
    }
}
