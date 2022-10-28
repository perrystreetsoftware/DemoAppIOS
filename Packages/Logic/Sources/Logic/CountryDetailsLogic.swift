//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import DomainModels
import Interfaces
import Combine
import Repositories

public class CountryDetailsLogic {
    private let countryDetailsRepository: CountryDetailsRepository

    public init(countryDetailsRepository: CountryDetailsRepository) {
        self.countryDetailsRepository = countryDetailsRepository
    }

    public func getDetails(country: Country) -> AnyPublisher<CountryDetails, CountryDetailsError> {
        return countryDetailsRepository
            .getDetails(regionCode: country.regionCode)
            .eraseToAnyPublisher()
    }
}
