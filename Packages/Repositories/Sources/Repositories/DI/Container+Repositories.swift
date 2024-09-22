//
//  Container+Repositories.swift
//  Put registrations that require name: parameters here
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import Swinject
import Interfaces
import SwinjectAutoregistration

public extension Container {
    func injectRepositories() -> Container {
        return self.injectRepositoriesGenerated()
    }
}
