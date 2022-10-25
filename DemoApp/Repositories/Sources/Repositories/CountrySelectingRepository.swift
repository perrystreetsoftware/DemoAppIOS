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

public enum CountrySelectingRepositoryError: Error, Equatable {
    case apiError(innerError: TravelAdvisoryApiError)
    case other

    public static func == (lhs: CountrySelectingRepositoryError, rhs: CountrySelectingRepositoryError) -> Bool {
        switch (lhs, rhs) {
        case (.apiError(let inner1), .apiError(let inner2)):
            return inner1 == inner2
        case (.other, .other):
            return true
        default:
            return false
        }
    }
}

public class CountrySelectingRepository {
    @Published public private(set) var continents: [Continent] = []
    private let countryListProviding: TravelAdvisoryApiImplementing

    public init(countryListProviding: TravelAdvisoryApiImplementing) {
        self.countryListProviding = countryListProviding
    }

    public func reload() -> AnyPublisher<Void, CountrySelectingRepositoryError> {
        return countryListProviding.getCountryList()
            .handleEvents(receiveOutput: { countryList in
                self.continents = [
                    ("Africa", countryList.africa),
                    ("Asia", countryList.asia),
                    ("Latin America", countryList.latam),
                    ("Oceana", countryList.oceania),
                    ("Europe", countryList.europe)
                ].map { name, countries in
                    Continent(name: name, countries: countries.map { Country(regionCode: $0)})
                }
            })
            .map { _ in }
            .mapError { .apiError(innerError: $0) }
        .eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountrySelectingRepositoryError> {
        return countryListProviding.getForbiddenApi().mapError { error in
            CountrySelectingRepositoryError.apiError(innerError: error)
        }.eraseToAnyPublisher()
    }
}
