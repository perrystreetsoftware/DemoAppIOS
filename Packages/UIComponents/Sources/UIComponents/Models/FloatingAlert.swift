//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/22/22.
//

import Foundation

public enum FloatingAlert {
    case dialog(_ config: DialogConfig)
    case toast(_ config: ToastConfig)
}
