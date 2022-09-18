//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Combine
import DomainModels

public final class MockCountryListProvider: CountryListProviding {
    public func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, CountryListProvidingError> {
        return Just(CountryDetailsDTO(area: "Asia", regionName: "Yemen", regionCode: "YE", legalCodeBody: "Article 264"))
            .delay(for: .seconds(3),
                   scheduler: DispatchQueue.main)
            .setFailureType(to: CountryListProvidingError.self)
            .eraseToAnyPublisher()

    }

    public func getCountryList() -> AnyPublisher<CountryListDTO, CountryListProvidingError> {
        return Just(CountryListDTO(africa: ["ug", "ng"]))
            .delay(for: .seconds(3),
                   scheduler: DispatchQueue.main)
            .setFailureType(to: CountryListProvidingError.self)
            .eraseToAnyPublisher()
    }
}
