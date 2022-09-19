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
import NetworkLogic

@main
struct TravelAdvisoriesApp: App {
    init() {
        InjectSettings.resolver = Container()
            .injectBusinessLogicViewModels()
            .injectBusinessLogicLogic()
            .injectBusinessLogicRepositories()
            .injectBusinessLogicLocalApis()
            .injectNetworkLogicRemoteApis()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
