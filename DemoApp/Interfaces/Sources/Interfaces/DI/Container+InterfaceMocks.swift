//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject

public extension Container {
    func injectInterfaceMocks() -> Container {
        self.register(TravelAdvisoryApiImplementing.self) { resolver in
            MockTravelAdvisoryApi(scheduler: resolver.resolve(AppSchedulerProviding.self)!)
        }.inObjectScope(.container)
        self.register(AppSchedulerProviding.self) { resolver in
            MockAppSchedulerProviding()
        }.inObjectScope(.container)

        return self
    }
}
