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
    
    /// This unit test is responsible for generating the package mocks. All interfaces declared here will have a generated mock on Mocks.generated file
    /// Run `./gen-mocks.sh` to generate these mocks
    
    func test_generate_mockingbird_mocks() {
        _ = mock(TravelAdvisoryApiImplementing.self)
    }
}
