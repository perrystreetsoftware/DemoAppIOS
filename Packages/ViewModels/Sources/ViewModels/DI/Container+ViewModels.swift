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
import Logic

public extension Container {
    func injectBusinessLogicViewModels() -> Container {
        self.autoregister(AboutViewModel.self, initializer: AboutViewModel.init).inObjectScope(.transient)
        self.autoregister(CountryListViewModel.self, initializer: CountryListViewModel.init).inObjectScope(.transient)
        self.register(CountryDetailsViewModel.self) { resolver, country in
            CountryDetailsViewModel(country: country,
                                    logic: resolver.resolve(CountryDetailsLogic.self)!)
        }.inObjectScope(.transient)
        self.autoregister(LatinAmericaFlagsViewModel.self, initializer: LatinAmericaFlagsViewModel.init).inObjectScope(.transient)
        
        return self
    }
}
