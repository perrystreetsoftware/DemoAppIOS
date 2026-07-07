//
//  HarmonizeFixtures.swift
//  LintRules
//
//  Fixture source for AssertionsTest. This file is NOT compiled into any target
//  (it lives outside Sources/ and Tests/) and is NOT scanned by any lint rule
//  (.harmonize.yaml excludes everything under LintRules). It is parsed
//  explicitly via SwiftSourceCode(url:) by the API infrastructure tests.
//

import Foundation

public class ViolatingFixture {
    public var value = 1
}

public class AnotherViolatingFixture {
    public var value = 2
}

public final class CleanFixture {
    public var value = 3
}
