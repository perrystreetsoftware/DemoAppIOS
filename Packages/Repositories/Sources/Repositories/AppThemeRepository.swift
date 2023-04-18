//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 09/03/23.
//

import Foundation
import DomainModels

public class AppThemeRepository {
    @Published public private(set) var currentTheme = AppTheme.free
    
    public init() {}
    
    public func setTheme(_ appTheme: AppTheme) {
        currentTheme = appTheme
    }
}
