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
    case repoError(innerError: CountryDetailsRepositoryError)
    case other
}

public class CountryDetailsLogic {
    private let countryDetailsRepository: CountryDetailsRepository

    public init(countryDetailsRepository: CountryDetailsRepository) {
        self.countryDetailsRepository = countryDetailsRepository
    }

    public func getDetails(country: CountryUIModel) -> AnyPublisher<CountryDetailsUIModel, CountryDetailsLogicError> {
        return countryDetailsRepository.getDetails(regionCode: country.regionCode).map { countryDetailsDTO in
            CountryDetailsUIModel(countryDetailsDTO: countryDetailsDTO)
        }.mapError { repoError in
                .repoError(innerError: repoError)
        }
        .eraseToAnyPublisher()
    }
}
