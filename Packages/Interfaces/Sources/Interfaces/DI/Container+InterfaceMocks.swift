//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Mockingbird

public extension Container {
    func injectInterfaceRemoteMocks() -> Container {
        self.register(TravelAdvisoryApiImplementing.self) { resolver in
            mock(TravelAdvisoryApiImplementing.self)
        }.inObjectScope(.container)

        return self
    }

    func injectInterfaceLocalMocks() -> Container {
        self.register(AppSchedulerProviding.self) { resolver in
            MockAppSchedulerProviding()
        }.inObjectScope(.container)

        return self
    }
}
