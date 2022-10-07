//
//  DemoAppApp.swift
//  Shared
//
//  Created by Eric Silverberg on 9/10/22.
//

import SwiftUI
import Swinject
import Utils
import Interfaces

@main
struct TravelAdvisoriesApp: App {
    init() {
        InjectSettings.resolver = Container()
            .injectBusinessLogicViewModels()
            .injectBusinessLogicLogic()
            .injectBusinessLogicRepositories()
            .injectBusinessLogicLocalApis()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
