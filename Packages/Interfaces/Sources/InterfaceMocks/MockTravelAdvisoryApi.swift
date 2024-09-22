//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import Interfaces
import Combine

public final class MockTravelAdvisoryApi: TravelAdvisoryApiImplementing {
    public func getForbiddenApi() -> AnyPublisher<Void, Interfaces.TravelAdvisoryApiError> {
        return Just(())
            .setFailureType(to: TravelAdvisoryApiError.self)
            .eraseToAnyPublisher()
    }

    public var getCountryListResult: Result<CountryListDTO, TravelAdvisoryApiError>?
    public var getCountryListPublisher: AnyPublisher<CountryListDTO, TravelAdvisoryApiError>?
    public func getCountryList() -> AnyPublisher<Interfaces.CountryListDTO, Interfaces.TravelAdvisoryApiError> {
        if let getCountryListResult {
            return getCountryListResult.publisher.eraseToAnyPublisher()
        } else if let getCountryListPublisher {
            return getCountryListPublisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }

    public var getCountryDetailsCount = 0
    public var getCountryDetailsResult: Result<CountryDetailsDTO, TravelAdvisoryApiError>?
    public var getCountryDetailsPublisher: AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError>?
    public func getCountryDetails(regionCode: String) -> AnyPublisher<Interfaces.CountryDetailsDTO, Interfaces.TravelAdvisoryApiError> {
        getCountryDetailsCount += 1
        
        if let getCountryDetailsResult {
            return getCountryDetailsResult.publisher.eraseToAnyPublisher()
        } else if let getCountryDetailsPublisher {
            return getCountryDetailsPublisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }

    public var getServerStatusResult: Result<ServerStatusDTO, TravelAdvisoryApiError>?
    public var getServerStatusPublisher: AnyPublisher<ServerStatusDTO, TravelAdvisoryApiError>?
    public func getServerStatus() -> AnyPublisher<Interfaces.ServerStatusDTO, Interfaces.TravelAdvisoryApiError> {
        if let getServerStatusResult {
            return getServerStatusResult.publisher.eraseToAnyPublisher()
        } else if let getServerStatusPublisher {
            return getServerStatusPublisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }


}
