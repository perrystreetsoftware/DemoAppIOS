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
    func injectViewModels() -> Container {
        self.register(CountryDetailsViewModel.self) { resolver, country in
            CountryDetailsViewModel(country: country,
                                    logic: resolver.resolve(CountryDetailsLogic.self)!)
        }.inObjectScope(.transient)

        return self.injectViewModelsGenerated()
    }
}
