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

public extension Container {
    func injectBusinessLogicRepositories() -> Container {
        self.autoregister(CountrySelectingRepository.self, initializer: CountrySelectingRepository.init).inObjectScope(.container)
        self.autoregister(CountryDetailsRepository.self, initializer: CountryDetailsRepository.init).inObjectScope(.container)
        self.autoregister(ServerStatusPushBasedRepository.self, initializer: ServerStatusPushBasedRepository.init).inObjectScope(.container)

        return self
    }
}
