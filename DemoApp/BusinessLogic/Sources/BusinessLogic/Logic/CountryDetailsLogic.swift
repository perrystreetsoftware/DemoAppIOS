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

public enum CountryDetailsLogicError: Error {
    case countryNotFound
    case other(error: TravelAdvisoryApiError)

    init(_ travelAdvisoryError: TravelAdvisoryApiError) {
        switch travelAdvisoryError {
        case .domainError(let apiError, _):
            switch apiError {
            case .countryNotFound:
                self = .countryNotFound
            case .forbidden:
                self = .other(error: travelAdvisoryError)
            }
        default:
            self = .other(error: travelAdvisoryError)
        }
    }
}

public class CountryDetailsLogic {
    private let countryDetailsRepository: CountryDetailsRepository

    public init(countryDetailsRepository: CountryDetailsRepository) {
        self.countryDetailsRepository = countryDetailsRepository
    }

    public func getDetails(country: Country) -> AnyPublisher<CountryDetails, CountryDetailsLogicError> {
        return countryDetailsRepository.getDetails(regionCode: country.regionCode).map { countryDetailsDTO in
            CountryDetails(countryDetailsDTO: countryDetailsDTO)
        }.mapError { CountryDetailsLogicError($0) }
        .eraseToAnyPublisher()
    }
}
