import Swinject
import SwinjectAutoregistration

// This file was auto-generated
public extension Container {
    func injectLogicGenerated() -> Container {
        self.autoregister(CountryDetailsLogic.self, initializer: CountryDetailsLogic.init).inObjectScope(.transient)
		self.autoregister(CountryListLogic.self, initializer: CountryListLogic.init).inObjectScope(.transient)
		self.autoregister(GetCurrentLocationLogic.self, initializer: GetCurrentLocationLogic.init).inObjectScope(.transient)
		self.autoregister(RequestNewLocationLogic.self, initializer: RequestNewLocationLogic.init).inObjectScope(.transient)
		self.autoregister(ServerStatusLogic.self, initializer: ServerStatusLogic.init).inObjectScope(.transient)
        return self
    }
}
