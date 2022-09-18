//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Combine
import DomainModels

public final class MockTravelAdvisoryApi: TravelAdvisoryApiImplementing {
    private let scheduler: AppSchedulerProviding

    public init(scheduler: AppSchedulerProviding) {
        self.scheduler = scheduler
    }

    public var getCountryDetailsResult: Result<CountryDetailsDTO, TravelAdvisoryApiError>?
    public func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError> {
        if let result = getCountryDetailsResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Just(CountryDetailsDTO(area: "Asia", regionName: "Yemen", regionCode: "YE", legalCodeBody: "Article 264"))
                .receive(on: scheduler.mainScheduler)
                .setFailureType(to: TravelAdvisoryApiError.self)
                .eraseToAnyPublisher()
        }
    }

    public var getCountryListResult: Result<CountryListDTO, TravelAdvisoryApiError>?
    public func getCountryList() -> AnyPublisher<CountryListDTO, TravelAdvisoryApiError> {
        if let result = getCountryListResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Just(CountryListDTO(africa: ["ug", "ng"]))
                .receive(on: scheduler.mainScheduler)
                .setFailureType(to: TravelAdvisoryApiError.self)
                .eraseToAnyPublisher()
        }
    }
}
