//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Mockingbird
import Interfaces
import Combine
import Utils

public extension Container {
    func injectInterfaceRemoteMocks() -> Container {
        self.register(TravelAdvisoryApiImplementing.self) { resolver in
            mock(TravelAdvisoryApiImplementing.self)
        }.inObjectScope(.container)

        return self
    }

    func injectInterfaceLocalMocks() -> Container {
        self.pss_registerMock(AppSchedulerProviding.self, MockAppSchedulerProviding.self, MockAppSchedulerProviding.init).inObjectScope(.container)

        return self
    }
}
