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

    public func reload() -> AnyPublisher<Void, CountryListError> {
        return countryListRepository.reload().eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountryListError> {
        countryListRepository.getForbiddenApi().eraseToAnyPublisher()
    }
}
