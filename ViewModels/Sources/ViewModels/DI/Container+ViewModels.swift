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
}
