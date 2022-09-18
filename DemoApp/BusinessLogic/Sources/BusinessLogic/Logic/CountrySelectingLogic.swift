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

public enum CountrySelectingLogicError: Error {
    case repoError(innerError: CountrySelectingRepositoryError)
    case other
}

public class CountrySelectingLogic {
    @Published public private(set) var continents: [ContinentUIModel]
    private let countrySelectingRepository: CountrySelectingRepository

    public init(countrySelectingRepository: CountrySelectingRepository) {
        self.countrySelectingRepository = countrySelectingRepository
        self.continents = countrySelectingRepository.continents

        countrySelectingRepository.$continents.assign(to: &$continents)
    }

    public func reload() -> AnyPublisher<Void, CountrySelectingLogicError> {
        return countrySelectingRepository.reload().mapError { repoError in
                .repoError(innerError: repoError)
        }.eraseToAnyPublisher()
    }
}
