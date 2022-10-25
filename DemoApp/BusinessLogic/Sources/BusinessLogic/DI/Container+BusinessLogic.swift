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
    func injectBusinessLogicViewModels() -> Container {
        self.autoregister(CountrySelectingViewModel.self, initializer: CountrySelectingViewModel.init).inObjectScope(.transient)
        self.register(CountryDetailsViewModelBuilder.self) { resolver in
            CountryDetailsViewModelBuilder(resolver: resolver)
        }.inObjectScope(.transient)

        return self
    }

    func injectBusinessLogicLogic() -> Container {
        self.autoregister(CountrySelectingLogic.self, initializer: CountrySelectingLogic.init).inObjectScope(.transient)
        self.autoregister(CountryDetailsLogic.self, initializer: CountryDetailsLogic.init).inObjectScope(.transient)
        self.autoregister(ServerStatusLogic.self, initializer: ServerStatusLogic.init).inObjectScope(.transient)

        return self
    }

    func injectBusinessLogicRepositories() -> Container {
        self.autoregister(CountrySelectingRepository.self, initializer: CountrySelectingRepository.init).inObjectScope(.container)
        self.autoregister(CountryDetailsRepository.self, initializer: CountryDetailsRepository.init).inObjectScope(.container)
        self.autoregister(ServerStatusPushBasedRepository.self, initializer: ServerStatusPushBasedRepository.init).inObjectScope(.container)

        return self
    }

    func injectBusinessLogicLocalApis() -> Container {
        self.autoregister(AppSchedulerProviding.self, initializer: AppSchedulerProvider.init).inObjectScope(.container)

        return self
    }
}
