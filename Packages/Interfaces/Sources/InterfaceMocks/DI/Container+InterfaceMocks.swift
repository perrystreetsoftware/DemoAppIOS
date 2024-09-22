//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Interfaces
import Combine
import Utils

public extension Container {
    func injectInterfaceRemoteMocks() -> Container {
        self.pss_registerMock(TravelAdvisoryApiImplementing.self, MockTravelAdvisoryApi.self, MockTravelAdvisoryApi.init).inObjectScope(.container)

        return self
    }

    func injectInterfaceLocalMocks() -> Container {
        return self
    }
}
