//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject

public extension Container {
    func injectInterfaceMocks() -> Container {
        self.register(CountryListProviding.self) { resolver in
            MockCountryListProvider()
        }.inObjectScope(.container)

        return self
    }
}
