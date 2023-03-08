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

public extension Container {
    func injectBusinessLogicLogic() -> Container {
        self.autoregister(CountryListLogic.self, initializer: CountryListLogic.init).inObjectScope(.transient)
        self.autoregister(CountryDetailsLogic.self, initializer: CountryDetailsLogic.init).inObjectScope(.transient)
        self.autoregister(ServerStatusLogic.self, initializer: ServerStatusLogic.init).inObjectScope(.transient)
        self.autoregister(GetLatinAmericaCountriesLogic.self, initializer: GetLatinAmericaCountriesLogic.init).inObjectScope(.transient)
        
        return self
    }

    func injectBusinessLogicRepositories() -> Container {
        self.autoregister(CountryListRepository.self, initializer: CountryListRepository.init).inObjectScope(.container)
        self.autoregister(CountryDetailsRepository.self, initializer: CountryDetailsRepository.init).inObjectScope(.container)
        self.autoregister(ServerStatusPushBasedRepository.self, initializer: ServerStatusPushBasedRepository.init).inObjectScope(.container)

        return self
    }
}
