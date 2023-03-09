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
        self.autoregister(AppThemeRepository.self, initializer: AppThemeRepository.init).inObjectScope(.container)
        self.autoregister(CountryListRepository.self, initializer: CountryListRepository.init).inObjectScope(.container)
        self.autoregister(CountryDetailsRepository.self, initializer: CountryDetailsRepository.init).inObjectScope(.container)
        self.autoregister(ServerStatusPushBasedRepository.self, initializer: ServerStatusPushBasedRepository.init).inObjectScope(.container)

        return self
    }
}
