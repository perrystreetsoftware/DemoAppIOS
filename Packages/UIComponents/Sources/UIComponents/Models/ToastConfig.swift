//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/22/22.
//

import Foundation

public struct ToastConfig {
    public init(message: LocalizedString) {
        self.message = message
    }

    let message: LocalizedString
}
