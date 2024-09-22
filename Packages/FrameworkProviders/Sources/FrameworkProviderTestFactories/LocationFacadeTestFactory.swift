//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import FrameworkProviderMocks

public final class LocationFacadeTestFactory {
    public static let FakeError = NSError(domain: "fake error", code: -1)
    private let api: MockLocationProvider!

    public init(_ container: Container) {
        api = container~>
    }

    public func withFailure() {
        api.nextError = Self.FakeError
    }
}
