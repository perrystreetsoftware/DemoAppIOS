//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Interfaces

public extension Container {
    func injectBusinessLogicViewModels() -> Container {
        self.register(CountrySelectingViewModel.self) { resolver in
            CountrySelectingViewModel(logic: resolver.resolve(CountrySelectingLogic.self)!)
        }.inObjectScope(.container)
        self.register(CountryDetailsViewModelBuilder.self) { resolver in
            CountryDetailsViewModelBuilder(resolver: resolver)
        }.inObjectScope(.container)

        return self
    }

    func injectBusinessLogicLogic() -> Container {
        self.register(CountrySelectingLogic.self) { resolver in
            CountrySelectingLogic(countrySelectingRepository: resolver.resolve(CountrySelectingRepository.self)!)
        }.inObjectScope(.container)
        self.register(CountryDetailsLogic.self) { resolver in
            CountryDetailsLogic(countryDetailsRepository: resolver.resolve(CountryDetailsRepository.self)!)
        }.inObjectScope(.container)

        return self
    }

    func injectBusinessLogicRepositories() -> Container {
        self.register(CountrySelectingRepository.self) { resolver in
            CountrySelectingRepository(countryListProviding: resolver.resolve(CountryListProviding.self)!)
        }.inObjectScope(.container)
        self.register(CountryDetailsRepository.self) { resolver in
            CountryDetailsRepository(countryListProviding: resolver.resolve(CountryListProviding.self)!)
        }.inObjectScope(.container)

        return self
    }
}
