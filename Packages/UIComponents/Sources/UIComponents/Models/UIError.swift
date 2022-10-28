//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/25/22.
//

import Foundation

public struct UIError {
    public let title: String
    public let messages: [String]

    public init(title: String, messages: [String]) {
        self.title = title
        self.messages = messages
    }
}
