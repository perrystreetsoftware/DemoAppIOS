//
//  File.swift
//  
//
//  Created by Eric Silverberg on 10/24/22.
//

import Foundation

public struct ServerStatus {
    public let success: Bool

    public init(success: Bool) {
        self.success = success
    }

    public static let Empty = ServerStatus(success: false)
}
