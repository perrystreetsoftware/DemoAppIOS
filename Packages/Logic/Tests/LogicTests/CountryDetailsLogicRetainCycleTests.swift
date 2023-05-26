import Quick
import Nimble
import Swinject
import Foundation
import DomainModels
import CombineExpectations
import Interfaces
import InterfaceMocks
import Combine
import Mockingbird
import Repositories

@testable import Logic

final class CountryDetailsLogicRetainCycleTests: XCTestCase {
    
    // MARK: Properties
    
    let container = Container()
        .injectBusinessLogicRepositories()
        .injectBusinessLogicLogic()
        .injectInterfaceLocalMocks()
        .injectInterfaceRemoteMocks()
    
    let country = Country(regionCode: "ng")

    lazy var repository = container.resolve(CountryDetailsRepository.self)!
    
    lazy var api: TravelAdvisoryApiImplementingMock = (container.resolve(TravelAdvisoryApiImplementing.self)! as! TravelAdvisoryApiImplementingMock)
    
    var strongReference: CountryDetailsLogic?
    weak var weakReference: CountryDetailsLogic?
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Test

    func test_retain_cycle() {
        given(api.getCountryDetails(regionCode: "ng")).willReturn(.just(.asia))
    
        strongReference = .init(countryDetailsRepository: repository)
        weakReference = strongReference
                
        let expectation = expectation(description: "Waiting next element be emitted")
        
        // Execute the subscription to cause the possible retain cycle
        strongReference?.getDetails(country: country)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { country in
                expectation.fulfill()
            }).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
        // Deallocate the strong reference and the subscription

        strongReference = nil
        cancellables = .init()
        
        XCTAssertNil(weakReference)
    }
}


//func test_retain_cycle_2() {
//    class Logic {
//        var currentSubject1 = CurrentValueSubject<Bool, Never>(true)
//        var currentSubject2 = CurrentValueSubject<Bool, Never>(true)
//
//        func get() -> AnyPublisher<Bool, Never> {
//            currentSubject1.flatMap { _ in self.currentSubject2 }.eraseToAnyPublisher()
//        }
//    }
//
//    var strong: Logic? = Logic()
//    weak var weakRef = strong
//
//    let expectation = expectation(description: "aa")
//
//    strong?.get().sink(receiveValue: { _ in
//        expectation.fulfill()
//    }).store(in: &cancellables)
//
//    wait(for: [expectation], timeout: 1)
//
//    strong = nil
//    cancellables = .init()
//
//    XCTAssertNil(weakRef)
//}
