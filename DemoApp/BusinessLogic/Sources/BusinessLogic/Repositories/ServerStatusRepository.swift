//
//  File.swift
//  
//
//  Created by Eric Silverberg on 10/24/22.
//

import Foundation
import DomainModels
import Interfaces
import Combine

public enum ServerStatusRepositoryError: Error, Equatable {
    case apiError(innerError: TravelAdvisoryApiError)
    case other

    public static func == (lhs: ServerStatusRepositoryError, rhs: ServerStatusRepositoryError) -> Bool {
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

public class ServerStatusPushBasedRepository {
    @Published public private(set) var status: ServerStatus = ServerStatus.Empty
    private let countryListProviding: TravelAdvisoryApiImplementing

    public init(countryListProviding: TravelAdvisoryApiImplementing) {
        self.countryListProviding = countryListProviding
    }

    public func reload() -> AnyPublisher<Void, ServerStatusRepositoryError> {
        return countryListProviding.getServerStatus()
            .map { ServerStatus(success: $0.ok) }
            .handleEvents(receiveOutput: { [weak self] serverStatus in
                self?.status = serverStatus
            })
            .mapError { .apiError(innerError: $0) }
            .map { _ in }
        .eraseToAnyPublisher()
    }

    public func getForbiddenApi() -> AnyPublisher<Void, CountrySelectingRepositoryError> {
        return countryListProviding.getForbiddenApi().mapError { error in
            CountrySelectingRepositoryError.apiError(innerError: error)
        }.eraseToAnyPublisher()
    }
}
