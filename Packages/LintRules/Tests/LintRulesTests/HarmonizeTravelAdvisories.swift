//
//  HarmonizeTravelAdvisories.swift
//  LintRules
//
//  Created by Eric Silverberg on 9/15/25.
//

import Harmonize

final class HarmonizeTravelAdvisories {
    private init() {}

    nonisolated(unsafe) static var viewModelsProduction = { classesProduction.withSuffix("ViewModel") }()
    nonisolated(unsafe) static var viewModelsPackage = { productionCode.on("ViewModels/Sources/ViewModels") }()

    nonisolated(unsafe) static var logicProduction = { classesProduction.withSuffix("Logic") }()
    nonisolated(unsafe) static var logicPackage = { productionCode.on("Logic/Sources/Logic") }()

    nonisolated(unsafe) static var classesProduction = { productionCode.classes(includeNested: true) }()

    nonisolated(unsafe) static var productionCode = { Harmonize.productionCode() }()
}
