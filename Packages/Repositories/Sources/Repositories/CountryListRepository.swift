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

public class CountryListRepository {
    @Published public private(set) var continents: [Continent] = []
    private let countryListProviding: TravelAdvisoryApiImplementing

    public init(countryListProviding: TravelAdvisoryApiImplementing) {
        self.countryListProviding = countryListProviding
    }

    public func reload() -> AnyPublisher<Void, CountryListError> {
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
            .mapError { error in
                CountryListError(apiError: error)
            }
        .eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountryListError> {
        return countryListProviding.getForbiddenApi().mapError { error in
            CountryListError(apiError: error)
        }.eraseToAnyPublisher()
    }
}

extension CountryListError {
    init(apiError: TravelAdvisoryApiError) {
        self = .connectionError(innerError: apiError)
    }
}
