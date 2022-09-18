//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import SwiftUI

public extension Binding {
    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> Binding<NewValue> {
        Binding<NewValue>(get: { transform(wrappedValue) }, set: { _ in })
    }
}

