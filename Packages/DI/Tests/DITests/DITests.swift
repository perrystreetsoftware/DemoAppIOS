import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(DIMacros)
import DIMacros

let testMacros: [String: Macro.Type] = [
    "DI": DIMacro.self
]
#endif

final class DITests: XCTestCase {

    func testDI() throws {
        assertMacroExpansion(
            """
            @DI
            final public class AccountRepository {
                private let accountApi: AccountApiImplementing
                private let someOtherApi: SomeOtherApiImplementing
                private var thisShouldBeIgnored: Int { 5 }
            }
            """,
            expandedSource: """
            final public class AccountRepository {
                private let accountApi: AccountApiImplementing
                private let someOtherApi: SomeOtherApiImplementing
                private var thisShouldBeIgnored: Int { 5 }

                init(accountApi: AccountApiImplementing, someOtherApi: SomeOtherApiImplementing) {
                    self.accountApi = accountApi
                self.someOtherApi = someOtherApi
                }
            }
            """,
            macros: testMacros
        )
    }

    func testSkipInit() throws {
        assertMacroExpansion(
            """
            @DI
            final public class AccountRepository {
                private let accountApi: AccountApiImplementing
                private let someOtherApi: SomeOtherApiImplementing
                private var thisShouldBeIgnored: Int { 5 }

                init() {
                }
            }
            """,
            expandedSource: """
            final public class AccountRepository {
                private let accountApi: AccountApiImplementing
                private let someOtherApi: SomeOtherApiImplementing
                private var thisShouldBeIgnored: Int { 5 }

                init() {
                }
            }
            """,
            macros: testMacros
        )
    }

    func testSkipPublished() throws {
        assertMacroExpansion(
            """
            @DI
            public final class ProfileViewMediator {
                @Published public private(set) var profilePhotoIndicator: ProfilePhotoIndicator = .photo(index: 0)
            }
            """,
            expandedSource: """
            public final class ProfileViewMediator {
                @Published public private(set) var profilePhotoIndicator: ProfilePhotoIndicator = .photo(index: 0)

                init() {
                }
            }
            """,
            macros: testMacros
        )
    }

}
