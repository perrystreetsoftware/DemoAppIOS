//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Swinject
import Mockingbird
import Interfaces
import Combine

public extension Container {
    func injectInterfaceRemoteMocks() -> Container {
        self.register(TravelAdvisoryApiImplementing.self) { resolver in
            mock(TravelAdvisoryApiImplementing.self)
        }.inObjectScope(.container)

        self.register(CameraAudioAndVideoPermissionsApiImplementing.self) { resolver in
            MockCameraAudioAndVideoPermissionsAPI()
        }.inObjectScope(.container)
        
        return self
    }

    func injectInterfaceLocalMocks() -> Container {
        self.register(AppSchedulerProviding.self) { resolver in
            MockAppSchedulerProviding()
        }.inObjectScope(.container)

        return self
    }
}
