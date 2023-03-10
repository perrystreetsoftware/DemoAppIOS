//
//  File.swift
//  
//
//  Created by Oscar Gonzalez on 10/03/23.
//

import Foundation

public class Stylesheet: ObservableObject {
    
    public static let shared = Stylesheet()
    @Published public var currentTheme: ThemeImplementing = FreeTheme()
}
