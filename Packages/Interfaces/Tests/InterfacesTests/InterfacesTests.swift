import Mockingbird
import XCTest
@testable import Interfaces

final class InterfacesTests: XCTestCase {
    func testGenerateMocks() throws {
        let mock = mock(TravelAdvisoryApiImplementing.self)
    }
}
