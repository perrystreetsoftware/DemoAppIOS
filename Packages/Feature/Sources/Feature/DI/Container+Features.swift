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
import FrameworkProviderProtocols

public extension Container {
    func injectBusinessLogicLocalApis() -> Container {
        return self
    }
}
