//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/22/22.
//

import Foundation

public enum FloatingAlert {
    case dialog(_ state: DialogUiState)
    case toast(_ state: ToastUiState)
}
