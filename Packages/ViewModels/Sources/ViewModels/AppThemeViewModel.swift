//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 09/03/23.
//

import Foundation
import DomainModels
import Combine
import Logic

public class AppThemeViewModel: ObservableObject {
    @Published public private(set) var currentTheme: AppTheme
    
    private var appThemeLogic: AppThemeLogic
    
    init(appThemeLogic: AppThemeLogic) {
        self.appThemeLogic = appThemeLogic
        
        currentTheme = appThemeLogic.currentTheme
        appThemeLogic.$currentTheme.dropFirst().assign(to: &$currentTheme)
    }
    
    public func toggleTheme() {
        switch currentTheme {
        case .free:
            appThemeLogic.changeAppTheme(to: .pro)
        case .pro:
            appThemeLogic.changeAppTheme(to: .free)
        }
    }
}
