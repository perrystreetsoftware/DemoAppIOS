// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary) // TODO: the name should be just init, we're only generating the initializer. Just does not work for some reason.
public macro DI() = #externalMacro(module: "DIMacros", type: "DIMacro")

@attached(member, names: arbitrary)
public macro Factory() = #externalMacro(module: "DIMacros", type: "DIMacro")

@attached(member, names: arbitrary)
public macro WeakFactory() = #externalMacro(module: "DIMacros", type: "DIMacro")

@attached(member, names: arbitrary)
public macro Single() = #externalMacro(module: "DIMacros", type: "DIMacro")
