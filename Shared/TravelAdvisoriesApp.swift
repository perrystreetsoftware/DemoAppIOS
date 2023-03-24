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
import Feature
import UIComponents

@main
struct TravelAdvisoriesApp: App {
    private var themeMediator: ThemeMediator
    
    init() {
        InjectSettings.resolver = Container()
            .injectBusinessLogicViewModels()
            .injectBusinessLogicLogic()
            .injectBusinessLogicRepositories()
            .injectBusinessLogicLocalApis()
            .injectNetworkLogicRemoteApis()
        
        themeMediator = InjectSettings.resolver!.resolve(ThemeMediator.self)!
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
