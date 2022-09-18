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

public enum CountryDetailsRepositoryError: Error {
    case apiError(innerError: CountryListProvidingError)
    case other
}

public class CountryDetailsRepository {
    private let countryListProviding: CountryListProviding

    public init(countryListProviding: CountryListProviding) {
        self.countryListProviding = countryListProviding
    }

    public func getDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, CountryDetailsRepositoryError> {
        return countryListProviding.getCountryDetails(regionCode: regionCode)
            .mapError { .apiError(innerError: $0) }
        .eraseToAnyPublisher()
    }
}
