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

public enum ServerStatusLogicError: Error {
    case forbidden
    case repoError(innerError: ServerStatusRepositoryError)
    case other

    init(_ repoError: ServerStatusRepositoryError) {
        switch repoError {
        case .apiError(let innerError):
            switch innerError {
            case .domainError(let domainError, _):
                switch domainError {
                case .forbidden:
                    self = .forbidden
                default:
                    self = .other
                }
            default:
                self = .other
            }
        default:
            self = .repoError(innerError: repoError)
        }
    }
}

@Factory
public final class ServerStatusLogic {
    private let serverStatusRepository: ServerStatusPushBasedRepository

    @Published public var serverStatus: ServerStatus

    init(serverStatusRepository: ServerStatusPushBasedRepository) {
        self.serverStatusRepository = serverStatusRepository

        self.serverStatus = serverStatusRepository.status

        serverStatusRepository.$status.dropFirst().assign(to: &$serverStatus)
    }

    public func reload() -> AnyPublisher<Void, ServerStatusLogicError> {
        return serverStatusRepository.reload().mapError { error in
            ServerStatusLogicError(error)
        }.eraseToAnyPublisher()
    }
}
