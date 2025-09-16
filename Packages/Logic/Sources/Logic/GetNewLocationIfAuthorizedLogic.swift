//
//  RequestLocationAuthorizationLogic.swift
//  Logic
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Repositories
import Combine
import DI
import DomainModels

@Factory
public final class GetNewLocationIfAuthorizedLogic {
    private let getIsLocationAuthorizedLogic: GetIsLocationAuthorizedLogic
    private let getNewLocationLogic: GetNewLocationLogic

    public func callAsFunction() -> AnyPublisher<Void, LocationLogicError> {
        return getIsLocationAuthorizedLogic()
            .flatMap { _ in
                self.getNewLocationLogic()
                    .eraseToAnyPublisher()
            }
        .eraseToAnyPublisher()
    }
}

