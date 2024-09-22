import Foundation
import Combine
import DomainModels

public protocol LocationProvidingDelegate: AnyObject {
    func didUpdateLocation(locations: [PSSLocation])
    func didFailWithError(error: Error)
}

public protocol LocationProviding {
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func setDelegate(delegate: LocationProvidingDelegate?)
}
