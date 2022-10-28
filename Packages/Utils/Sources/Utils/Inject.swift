//
//  Inject.swift
//
//
//  Created by Peter Verhage on 01/07/2019.
//

import Swinject

@propertyWrapper
public struct Inject<Value> {
    public private(set) var wrappedValue: Value

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

        wrappedValue = value
    }

    public init<Wrapped>(name: String? = nil, resolver: Resolver? = nil) where Value == Wrapped? {
        guard let resolver = resolver ?? InjectSettings.resolver else {
            fatalError("Make sure InjectSettings.resolver is set!")
        }

        wrappedValue = resolver.resolve(Wrapped.self, name: name)
    }
}

///
/// Copied from: https://github.com/guillermomuntaner/Burritos/blob/master/Sources/Lazy/Lazy.swift
/// But using our Swinject implementation to create the value
///
/// A property wrapper which delays instantiation until first read access.
///
/// It is a reimplementation of Swift `lazy` modifier using a property wrapper.
/// As an extra on top of `lazy` it offers reseting the wrapper to its "uninitialized" state.
///
@propertyWrapper
public struct LazyInject<Value> {
    let name: String?
    var storage: Value?
    let resolver: Resolver?

    public init(name: String? = nil, resolver: Resolver? = nil) {
        self.name = name
        self.resolver = resolver
    }

    /// Creates a lazy property with the closure to be executed to provide an initial value once the wrapped property is first accessed.
    ///
    /// This constructor is automatically used when assigning the initial value of the property, so simply use:
    ///
    ///     @Lazy var text = "Hello, World!"
    ///
    public init<Wrapped>(name: String? = nil, resolver: Resolver? = nil) where Value == Wrapped? {
        self.name = name
        self.resolver = resolver
    }

    public var wrappedValue: Value {
        mutating get {
            if storage == nil {
                guard let resolver = self.resolver ?? InjectSettings.resolver else {
                    preconditionFailure("No resolver set")
                }

                storage = resolver.resolve(Value.self, name: name)
            }

            return storage!
        }
        set {
            storage = newValue
        }
    }

    // MARK: Utils

    /// Resets the wrapper to its initial state. The wrapped property will be initialized on next read access.
    public mutating func reset() {
        storage = nil
    }
}
