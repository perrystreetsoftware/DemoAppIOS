//
//  File.swift
//  
//
//  Created by Eric Silverberg on 2/4/23.
//

import Foundation
import Nimble

public func beApproximately(_ of: Date) -> Nimble.Predicate<Date> {
    return beWithin(10, of: of)
}

public func beWithin(_ interval: TimeInterval, of: Date) -> Nimble.Predicate<Date> {
    return Nimble.Predicate.define("be <content>") { expression, message in
        guard let actual = try expression.evaluate() else {
            return PredicateResult(status: .fail, message: message)
        }

        if abs(actual.timeIntervalSince1970 - of.timeIntervalSince1970) <= interval {
            return PredicateResult(status: .matches, message: message)
        }

        return PredicateResult(status: .doesNotMatch, message: message)
    }
}

#if !os(macOS)
import UIKit
public func beSameImage(_ expectedData: UIImage) -> Nimble.Predicate<UIImage> {
    return Predicate.define("be <content>") { expression, message in
        guard let actualData = try expression.evaluate() else {
            return PredicateResult(status: .fail, message: message)
        }

        if expectedData.pngData() == actualData.pngData() {
            return PredicateResult(status: .matches, message: message)
        } else {
            return PredicateResult(status: .doesNotMatch, message: message)
        }
    }
}
#else
import AppKit
public func beSameImage(_ expectedData: NSImage) -> Nimble.Predicate<NSImage> {
    return Nimble.Predicate.define("be <content>") { expression, message in
        guard let actualData = try expression.evaluate() else {
            return PredicateResult(status: .fail, message: message)
        }

        if expectedData.tiffRepresentation == actualData.tiffRepresentation {
            return PredicateResult(status: .matches, message: message)
        } else {
            return PredicateResult(status: .doesNotMatch, message: message)
        }
    }
}
#endif
