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


    public func getForbiddenApi() -> AnyPublisher<Void, TravelAdvisoryApiError> {
        return Just(())
            .setFailureType(to: TravelAdvisoryApiError.self)
            .eraseToAnyPublisher()
    }

    public var getCountryDetailsResult: Result<CountryDetailsDTO, TravelAdvisoryApiError>?
    public private(set) var getCountryDetailsRegionCodePassed: String?
    public private(set) var getCountryDetailsRegionCallsCount: Int = 0

    public func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError> {
        getCountryDetailsRegionCallsCount += 1
        getCountryDetailsRegionCodePassed = regionCode
        
        if let result = getCountryDetailsResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Just(CountryDetailsDTO(area: "Asia",
                                          regionName: Locale.current.localizedString(forRegionCode: regionCode)!,
                                          regionCode: regionCode,
                                          legalCodeBody: "Article 264"))
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

    public var getServerStatusResult: Result<ServerStatusDTO, TravelAdvisoryApiError>?
    public func getServerStatus() -> AnyPublisher<ServerStatusDTO, TravelAdvisoryApiError> {
        if let result = getServerStatusResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Just(ServerStatusDTO.Empty).setFailureType(to: TravelAdvisoryApiError.self).eraseToAnyPublisher()
        }
    }
}
