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
import DI

@Single
public final class CountryDetailsRepository {
    private let countryListProviding: TravelAdvisoryApiImplementing

    // We do not do any mapping because we are not transforming or defining any new errors
    public func getDetails(regionCode: String) -> AnyPublisher<CountryDetails, CountryDetailsError> {
        return countryListProviding
            .getCountryDetails(regionCode: regionCode)
            .map { CountryDetails(countryDetailsDTO: $0) }
            .mapError({ error in
                CountryDetailsError(apiError: error)
            })
            .eraseToAnyPublisher()
    }
}

private extension CountryDetailsError {
    init(apiError: TravelAdvisoryApiError) {
        self = {
            switch apiError {
            case .domainError(let domainError, _):
                switch domainError {
                case .countryNotFound:
                    return .countryNotFound
                default:
                    return .other
                }
            default:
                return .other
            }
        }()
    }
}
private extension CountryDetails {
    init(countryDetailsDTO: CountryDetailsDTO) {
        self.init(country: Country(regionCode: countryDetailsDTO.regionCode),
                  detailsText: countryDetailsDTO.legalCodeBody)
    }
}
