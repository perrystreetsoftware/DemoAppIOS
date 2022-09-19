//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Interfaces

public extension Container {
    func injectNetworkLogic() -> Container {
        self.register(TravelAdvisoryApiImplementing.self) { resolver in
            TravelAdvisoryApi(appScheduler: resolver.resolve(AppSchedulerProviding.self)!)
        }.inObjectScope(.container)

        return self
    }
}
