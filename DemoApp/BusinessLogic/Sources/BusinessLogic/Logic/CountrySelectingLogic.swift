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
    case forbidden
    case repoError(innerError: CountrySelectingRepositoryError)
    case other

    init(_ repoError: CountrySelectingRepositoryError) {
        switch repoError {
        case .apiError(let innerError):
            switch innerError {
            case .domainError(let domainError, _):
                switch domainError {
                case .forbidden:
                    self = .forbidden
                default:
                    self = .other
                }
            default:
                self = .other
            }
        default:
            self = .repoError(innerError: repoError)
        }
    }
}

public class CountrySelectingLogic {
    private static let InvalidContinent = Continent(name: "Invalid", countries: [Country(regionCode: "xx")])
    @Published public private(set) var continents: [Continent]
    private let countrySelectingRepository: CountrySelectingRepository

    public init(countrySelectingRepository: CountrySelectingRepository) {
        self.countrySelectingRepository = countrySelectingRepository
        self.continents = countrySelectingRepository.continents

        countrySelectingRepository.$continents
            .dropFirst()
            .map({ continents in
                return [Self.InvalidContinent] + continents
            })
            .assign(to: &$continents)
    }

    public func reload() -> AnyPublisher<Void, CountrySelectingLogicError> {
        return countrySelectingRepository.reload().mapError {
            CountrySelectingLogicError($0)
        }.eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountrySelectingLogicError> {
        countrySelectingRepository.getForbiddenApi().mapError {
            CountrySelectingLogicError($0)
        }.eraseToAnyPublisher()
    }
}
