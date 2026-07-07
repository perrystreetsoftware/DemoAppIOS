//
//  HarmonizeTravelAdvisories.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Foundation
import Harmonize
import HarmonizeSemantics
import SwiftUI


final class HarmonizeTravelAdvisories {
    private init() {}

    nonisolated(unsafe) static var viewModelsProduction = { classesProduction.withSuffix("ViewModel") }()
    nonisolated(unsafe) static var viewModelsPackage = { productionCode.on("ViewModels/Sources/ViewModels") }()

    nonisolated(unsafe) static var logicProduction = { classesProduction.withSuffix("Logic") }()
    nonisolated(unsafe) static var logicPackage = { productionCode.on("Logic/Sources/Logic") }()

    nonisolated(unsafe) static var repositoriesProduction = { classesProduction.withSuffix("Repository") }()
    nonisolated(unsafe) static var repositoriesPackage = { productionCode.on("Repositories/Sources/Repositories") }()

    nonisolated(unsafe) static var domainModelsPackage = { productionCode.on("DomainModels/Sources/DomainModels") }()

    nonisolated(unsafe) static var interfacesPackage = { productionCode.on("Interfaces/Sources/Interfaces") }()

    nonisolated(unsafe) static var frameworkProvidersPackage = { productionCode.on("FrameworkProviders/Sources/FrameworkProviders") }()

    nonisolated(unsafe) static var uiComponentsPackage = { productionCode.on("UIComponents/Sources/UIComponents") }()

    nonisolated(unsafe) static var classesProduction = { productionCode.classes(includeNested: true) }()

    nonisolated(unsafe) static var protocolsProduction = { productionCode.protocols(includeNested: true) }()

    nonisolated(unsafe) static var presentationFeaturePackage = {
        productionCode.on("Feature/Sources/Feature")
    }()

    nonisolated(unsafe) static var productionCode = { Harmonize.productionCode() }()

    nonisolated(unsafe) static var productionAndTestCode = { Harmonize.productionAndTestCode() }()

    nonisolated(unsafe) static var testCode = { Harmonize.testCode() }()

    nonisolated(unsafe) static var classesTest = { testCode.classes(includeNested: true) }()
}

extension Excluding {
    var views: [Struct] {
        structs(includeNested: true).conforming(to: (any View).self)
    }
}
