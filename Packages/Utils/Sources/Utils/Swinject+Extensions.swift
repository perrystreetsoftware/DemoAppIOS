import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    @discardableResult
    public func pss_registerMock<Service, Mock>(
        _ service: Service.Type,
        _ mock: Mock.Type,
        _ initializer: @escaping (()) -> Service
    ) -> ServiceEntry<Service> {
        assert(String(describing: service).hasSuffix("ing"))
        assert(String(describing: mock).hasPrefix("Mock"))

        return self.autoregister(service, initializer: initializer)
            .implements(mock)
            .inObjectScope(.container)
    }

    @discardableResult
    public func pss_registerMock<Service, Mock, A>(
        _ service: Service.Type,
        _ mock: Mock.Type,
        _ initializer: @escaping ((A)) -> Service
    ) -> ServiceEntry<Service> {
        assert(String(describing: service).hasSuffix("ing"))
        assert(String(describing: mock).hasPrefix("Mock"))

        return self.autoregister(service, initializer: initializer)
            .implements(mock)
            .inObjectScope(.container)
    }

    @discardableResult
    public func pss_registerMock<Service, Mock, A, B>(
        _ service: Service.Type,
        _ mock: Mock.Type,
        _ initializer: @escaping ((A, B)) -> Service
    ) -> ServiceEntry<Service> {
        assert(String(describing: service).hasSuffix("ing"))
        assert(String(describing: mock).hasPrefix("Mock"))

        return self.autoregister(service, initializer: initializer)
            .implements(mock)
            .inObjectScope(.container)
    }
}
