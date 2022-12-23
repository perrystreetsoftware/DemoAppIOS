//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/22/22.
//

import Foundation

public struct ToastUiState {
    public init(message: LocalizedString) {
        self.message = message
    }

    let message: LocalizedString
}
