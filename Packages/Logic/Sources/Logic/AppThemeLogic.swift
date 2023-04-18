//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 09/03/23.
//

import Foundation
import DomainModels
import Combine
import Repositories

public class AppThemeLogic {
    
    @Published public private(set) var currentTheme: AppTheme
    
    private let appThemeRepository: AppThemeRepository

    public init(appThemeRepository: AppThemeRepository) {
        self.appThemeRepository = appThemeRepository
        
        currentTheme = appThemeRepository.currentTheme
        appThemeRepository.$currentTheme.dropFirst().assign(to: &$currentTheme)
    }

    public func changeAppTheme(to theme: AppTheme) {
        return appThemeRepository.setTheme(theme)
    }
}
