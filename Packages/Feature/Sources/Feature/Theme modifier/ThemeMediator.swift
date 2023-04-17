//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 10/03/23.
//

import Foundation
import Logic
import UIComponents
import DomainModels
import Utils
import Combine

public class ThemeMediator {
    
    @Inject private var stylesheet: Stylesheet
    @Inject private var themeLogic: AppThemeLogic
    
    var cancellables = Set<AnyCancellable>()
    
    public init() {
        stylesheet.currentTheme = ThemeFactory.build(theme: themeLogic.currentTheme)
        
        themeLogic
            .$currentTheme
            .dropFirst()
            .map { ThemeFactory.build(theme: $0) }
            .assign(to: &stylesheet.$currentTheme)
    }
}

public struct ThemeFactory {
    public static func build(theme: AppTheme) -> ThemeImplementing {
        switch theme {
        case .free:
            return FreeTheme()
        case .pro:
            return ProTheme()
        }
    }
}
