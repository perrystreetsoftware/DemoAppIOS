import Swinject
import SwinjectAutoregistration

// This file was auto-generated
public extension Container {
    func injectLogicGenerated() -> Container {
        self.autoregister(CountryDetailsLogic.self, initializer: CountryDetailsLogic.init).inObjectScope(.transient)
		self.autoregister(CountryListLogic.self, initializer: CountryListLogic.init).inObjectScope(.transient)
		self.autoregister(GetCurrentLocationLogic.self, initializer: GetCurrentLocationLogic.init).inObjectScope(.transient)
		self.autoregister(GetIsLocationAuthorizedLogic.self, initializer: GetIsLocationAuthorizedLogic.init).inObjectScope(.transient)
		self.autoregister(GetLocationErrorLogic.self, initializer: GetLocationErrorLogic.init).inObjectScope(.transient)
		self.autoregister(GetNewLocationIfAuthorizedLogic.self, initializer: GetNewLocationIfAuthorizedLogic.init).inObjectScope(.transient)
		self.autoregister(GetNewLocationLogic.self, initializer: GetNewLocationLogic.init).inObjectScope(.transient)
		self.autoregister(ServerStatusLogic.self, initializer: ServerStatusLogic.init).inObjectScope(.transient)
        return self
    }
}
