import Swinject
import SwinjectAutoregistration

// This file was auto-generated
public extension Container {
    func injectRepositoriesGenerated() -> Container {
        self.autoregister(CountryDetailsRepository.self, initializer: CountryDetailsRepository.init).inObjectScope(.container)
		self.autoregister(CountryListRepository.self, initializer: CountryListRepository.init).inObjectScope(.container)
		self.autoregister(LocationRepository.self, initializer: LocationRepository.init).inObjectScope(.container)
		self.autoregister(ServerStatusPushBasedRepository.self, initializer: ServerStatusPushBasedRepository.init).inObjectScope(.container)
        return self
    }
}
