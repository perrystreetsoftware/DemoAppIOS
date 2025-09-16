import Foundation
import Combine
import FrameworkProviderProtocolModels

public protocol LocationProviding {
    var authorizationStatus: LocationAuthorizationStatus { get }
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func setDelegate(delegate: LocationProvidingDelegate?)
}
