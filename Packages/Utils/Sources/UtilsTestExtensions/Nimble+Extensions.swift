//
//  File.swift
//  
//
//  Created by Eric Silverberg on 2/4/23.
//

import Foundation
import Nimble

public func beApproximately(_ of: Date) -> Matcher<Date> {
    return beWithin(10, of: of)
}

public func beWithin(_ interval: TimeInterval, of: Date) -> Matcher<Date> {
    return Matcher.define("be <content>") { expression, message in
        guard let actual = try expression.evaluate() else {
            return MatcherResult(status: .fail, message: message)
        }

        if abs(actual.timeIntervalSince1970 - of.timeIntervalSince1970) <= interval {
            return MatcherResult(status: .matches, message: message)
        }

        return MatcherResult(status: .doesNotMatch, message: message)
    }
}

#if !os(macOS)
import UIKit
public func beSameImage(_ expectedData: UIImage) -> Matcher<UIImage> {
    return Matcher.define("be <content>") { expression, message in
        guard let actualData = try expression.evaluate() else {
            return MatcherResult(status: .fail, message: message)
        }

        if expectedData.pngData() == actualData.pngData() {
            return MatcherResult(status: .matches, message: message)
        } else {
            return MatcherResult(status: .doesNotMatch, message: message)
        }
    }
}
#else
import AppKit
public func beSameImage(_ expectedData: NSImage) -> Matcher<NSImage> {
    return Matcher.define("be <content>") { expression, message in
        guard let actualData = try expression.evaluate() else {
            return MatcherResult(status: .fail, message: message)
        }

        if expectedData.tiffRepresentation == actualData.tiffRepresentation {
            return MatcherResult(status: .matches, message: message)
        } else {
            return MatcherResult(status: .doesNotMatch, message: message)
        }
    }
}
#endif
