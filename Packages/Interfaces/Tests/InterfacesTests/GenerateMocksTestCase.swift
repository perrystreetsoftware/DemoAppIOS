//
//  File.swift
//  
//
//  Created by Matheus Dutra on 21/11/22.
//

import Foundation
import Interfaces
import Mockingbird
import InterfacesMocks

class GenerateMocksTestCase: XCTestCase {
    func test_generate_mockingbird_mocks() {
        _ = mock(TravelAdvisoryApiImplementing.self)
    }
}
