//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/21/22.
//

import Foundation

extension Array where Element == LocalizedString {
    public var joinedByDefaultSeparator: String {
        self.map { $0.stringValue }.joined(separator: " ")
    }
}
