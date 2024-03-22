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
import FrameworkProviders
import SDWebImageSVGCoder

@main
struct TravelAdvisoriesApp: App {
    init() {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)

        InjectSettings.resolver = Container()
            .injectBusinessLogicViewModels()
            .injectBusinessLogicLogic()
            .injectBusinessLogicRepositories()
            .injectBusinessLogicLocalApis()
            .injectNetworkLogicRemoteApis()
            .injectFrameworkProviders()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
