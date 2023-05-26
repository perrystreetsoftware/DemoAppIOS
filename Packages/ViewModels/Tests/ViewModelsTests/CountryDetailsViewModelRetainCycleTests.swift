import Quick
import Nimble
import Swinject
import Foundation
import DomainModels
import CombineExpectations
import Interfaces
import InterfaceMocks
import Logic
import Combine
import Mockingbird
import RepositoriesMocks
@testable import ViewModels

final class CountryDetailsViewModelRetainCycleTests: XCTestCase {
       
    let container = Container().injectBusinessLogicRepositories()
        .injectBusinessLogicLogic()
        .injectInterfaceLocalMocks()
        .injectInterfaceRemoteMocks()
    
    lazy var logic = container.resolve(CountryDetailsLogic.self)!
    let country = Country(regionCode: "ng")

    var strongReference: CountryDetailsViewModel?
    weak var weakReference: CountryDetailsViewModel?
    
    lazy var api = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)

    // MARK: Unit tests
    
    func test_retain_cycle() {
        given(api.getCountryDetails(regionCode: "ng")).willReturn(.just(.asia))
    
        strongReference = .init(
            country: country,
            logic: logic
        )
        
        weakReference = strongReference
        strongReference = nil
        
        XCTAssertNil(weakReference)
    }
}
