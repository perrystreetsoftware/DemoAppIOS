import Foundation
import Swinject
import SwinjectAutoregistration
import FrameworkProviderFacades
import FrameworkProviderProtocols

public extension Container {
    func injectFrameworkProviders() -> Container {
        self.autoregister(LocationProviding.self, initializer: LocationProvider.init).inObjectScope(.container)
        return self.injectFrameworkProviderFacades()
    }
}
