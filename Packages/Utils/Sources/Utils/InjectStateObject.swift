/// Copied from https://stackoverflow.com/a/64776324/705309
/// But using our Swinject implementation to create the value
///
/// An implementation of inject that works with swiftUI's dynamic properties

import Swinject
import SwiftUI

@propertyWrapper
public struct InjectStateObject<Value>: DynamicProperty where Value: ObservableObject {

    @StateObject private var service: Value

    public init() {
        self.init(name: nil, resolver: nil)
    }

    public init(name: String? = nil, resolver: Resolver? = nil) {
        guard let resolver = resolver ?? InjectSettings.resolver else {
            fatalError("Make sure InjectSettings.resolver is set!")
        }

        guard let value = resolver.resolve(Value.self, name: name) else {
            fatalError("Could not resolve non-optional \(Value.self)")
        }

        _service = StateObject(wrappedValue: value)
    }

    public var wrappedValue: Value {
        get { return service }
    }

    public var projectedValue: ObservedObject<Value>.Wrapper {
        return self.$service
    }
}
