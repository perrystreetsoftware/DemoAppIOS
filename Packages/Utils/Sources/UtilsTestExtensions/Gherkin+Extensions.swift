import Quick

public func Given(_ description: String, closure: () -> Void) {
    QuickSpec.context("Given " + description, closure: closure)
}

public func And(_ description: String, closure: () -> Void) {
    QuickSpec.context("And " + description, closure: closure)
}

public func When(_ description: String, closure: () -> Void) {
    QuickSpec.context("When " + description, closure: closure)
}

public func Then(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) {
    QuickSpec.it("Then " + description, closure: closure)
}

// MARK: Focus

public func fGiven(_ description: String, closure: () -> Void) {
    QuickSpec.fcontext("Given " + description, closure: closure)
}

public func fAnd(_ description: String, closure: () -> Void) {
    QuickSpec.fcontext("And " + description, closure: closure)
}

public func fWhen(_ description: String, closure: () -> Void) {
    QuickSpec.fcontext("When " + description, closure: closure)
}

public func fThen(_ description: String, file: FileString = #file, line: UInt = #line, closure: @escaping () throws -> Void) {
    QuickSpec.fit("Then " + description, closure: closure)
}
