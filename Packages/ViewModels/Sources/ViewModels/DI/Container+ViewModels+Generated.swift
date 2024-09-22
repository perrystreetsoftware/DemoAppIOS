import Swinject
import SwinjectAutoregistration

// This file was auto-generated
public extension Container {
    func injectViewModelsGenerated() -> Container {
        self.autoregister(AboutViewModel.self, initializer: AboutViewModel.init).inObjectScope(.transient)
		self.autoregister(CountryDetailsViewModel.self, initializer: CountryDetailsViewModel.init).inObjectScope(.transient)
		self.autoregister(CountryListViewModel.self, initializer: CountryListViewModel.init).inObjectScope(.transient)
        return self
    }
}
