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

public enum CountrySelectingRepositoryError: Error {
    case apiError(innerError: CountryListProvidingError)
    case other
}

public class CountrySelectingRepository {
    @Published public private(set) var continents: [ContinentUIModel] = []
    private let countryListProviding: CountryListProviding

    public init(countryListProviding: CountryListProviding) {
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
                    ContinentUIModel(name: name, countries: countries.map { CountryUIModel(regionCode: $0)})
                }
            })
            .map { _ in }
            .mapError { .apiError(innerError: $0) }
        .eraseToAnyPublisher()
    }
}
