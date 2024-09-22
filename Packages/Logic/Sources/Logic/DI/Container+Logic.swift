//
//  Container+Logic.swift
//  Put registrations that require name: parameters here
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Interfaces
import SwinjectAutoregistration
import Repositories

public extension Container {
    func injectLogic() -> Container {
        return self.injectLogicGenerated()
    }
}
