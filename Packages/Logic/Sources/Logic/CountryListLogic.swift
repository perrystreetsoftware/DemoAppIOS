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
import DI

@Factory
public final class CountryListLogic {
    private static let NoPermissionsCountry = Country(regionCode: "XX Toast")
    private static let UnavailableCountry = Country(regionCode: "XX Dialog")
    private static let BlockedCountry = Country(regionCode: "XX Random")
    private static let XXCountry = Country(regionCode: "XX")
    private static let InvalidCountries = [XXCountry, NoPermissionsCountry, UnavailableCountry, BlockedCountry]
    private static let InvalidContinent = Continent(name: "", countries: InvalidCountries)

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

    public func reload() -> AnyPublisher<Void, CountryListError> {
        return countryListRepository.reload().eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountryListError> {
        countryListRepository.getForbiddenApi().eraseToAnyPublisher()
    }

    public func canAccessCountry(country: Country) -> AnyPublisher<Void, CountryListError> {
        if country == Self.NoPermissionsCountry {
            return Fail(error: CountryListError.notEnoughPermissions).eraseToAnyPublisher()
        } else if country == Self.BlockedCountry {
            return Fail(error: CountryListError.blocked).eraseToAnyPublisher()
        } else if country == Self.UnavailableCountry {
            return Fail(error: CountryListError.notAvailable).eraseToAnyPublisher()
        } else {
            return Just(()).setFailureType(to: CountryListError.self).eraseToAnyPublisher()
        }
    }

    public func getRandomCountry() -> Country? {
        countryListRepository.getRandomCountry()
    }
}
