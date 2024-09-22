//
//  File.swift
//
//
//  Created by Eric Silverberg on 12/4/22.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import FrameworkProviderProtocols
import Interfaces
import Utils

public extension Container {
    func injectFrameworkProviderFacades() -> Container {
        self.autoregister(LocationProviderFacade.self, initializer: LocationProviderFacade.init).inObjectScope(.container)
        return self
    }
}
