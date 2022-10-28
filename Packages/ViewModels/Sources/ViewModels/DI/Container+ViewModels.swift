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
        self.autoregister(CountryListViewModel.self, initializer: CountryListViewModel.init).inObjectScope(.transient)
        self.register(CountryDetailsViewModelFactory.self) { resolver in
            CountryDetailsViewModelFactory(resolver: resolver)
        }.inObjectScope(.transient)

        return self
    }
}
