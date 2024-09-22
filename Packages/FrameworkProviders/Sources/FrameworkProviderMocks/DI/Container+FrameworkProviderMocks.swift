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
    func injectFrameworkProviderMocks() -> Container {
        self.pss_registerMock(LocationProviding.self, MockLocationProvider.self, MockLocationProvider.init)
        return self
    }
}
