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

public class CountryDetailsRepository {
    private let countryListProviding: TravelAdvisoryApiImplementing

    public init(countryListProviding: TravelAdvisoryApiImplementing) {
        self.countryListProviding = countryListProviding
    }

    // We do not do any mapping because we are not transforming or defining any new errors
    public func getDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError> {
        return countryListProviding.getCountryDetails(regionCode: regionCode)
        .eraseToAnyPublisher()
    }
}
