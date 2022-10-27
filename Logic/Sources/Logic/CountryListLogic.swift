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
import UIComponents

public enum CountryListLogicError: Error {
    case forbidden
    case repoError(innerError: CountryListRepositoryError)
    case other

    init(_ repoError: CountryListRepositoryError) {
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

public class CountryListLogic {
    private static let InvalidContinent = Continent(name: "", countries: [Country(regionCode: "xx")])
    @Published public private(set) var continents: [Continent]
    private let countryListRepository: CountryListRepository

    public init(countryListRepository: CountryListRepository) {
        self.countryListRepository = countryListRepository
        self.continents = countryListRepository.continents

        countryListRepository.$continents
            .dropFirst()
            .map({ continents in
                return [Self.InvalidContinent] + continents
            })
            .assign(to: &$continents)
    }

    public func reload() -> AnyPublisher<Void, CountryListLogicError> {
        return countryListRepository.reload().mapError {
            CountryListLogicError($0)
        }.eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountryListLogicError> {
        countryListRepository.getForbiddenApi().mapError {
            CountryListLogicError($0)
        }.eraseToAnyPublisher()
    }
}
