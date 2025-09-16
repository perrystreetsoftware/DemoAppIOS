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
import FrameworkProviderProtocolModels

public final class LocationFacadeTestFactory {
    public static let FakeError = NSError(domain: "fake error", code: -1)
    public static let EmpireStateLocation = PSSLocation(latitude: 40.748817, longitude: -73.985428)

    private let api: MockLocationProvider!

    public init(_ container: Container) {
        api = container~>
    }

    public func withFailure() {
        api.nextError = Self.FakeError
    }

    public func withLocationAuthorizedAlways() -> Self {
        api.authorizationStatus = .authorizedAlways
        return self
    }

    public func withLocationStatusNotDetermined() -> Self {
        api.authorizationStatus = .notDetermined
        return self
    }

    @discardableResult
    public func withLocationStatusDenied() -> Self {
        api.authorizationStatus = .denied
        return self
    }

    @discardableResult
    public func withNextLocationEmpireState() -> Self {
        api.nextLocation = Self.EmpireStateLocation
        return self
    }
}
