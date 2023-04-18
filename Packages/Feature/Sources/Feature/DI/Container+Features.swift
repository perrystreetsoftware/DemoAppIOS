//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Interfaces
import SwinjectAutoregistration
import Repositories
import UIComponents

public extension Container {
    func injectBusinessLogicLocalApis() -> Container {
        self.autoregister(AppSchedulerProviding.self, initializer: AppSchedulerProvider.init).inObjectScope(.container)
        self.autoregister(Stylesheet.self, initializer: Stylesheet.init).inObjectScope(.container)
        self.autoregister(ThemeMediator.self, initializer: ThemeMediator.init).inObjectScope(.container)

        return self
    }
}
