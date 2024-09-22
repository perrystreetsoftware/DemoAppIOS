import CoreLocation
import FrameworkProviderProtocols
import Combine
import DomainModels

public final class LocationProvider: NSObject, LocationProviding, CLLocationManagerDelegate {
    private let manager: CLLocationManager

    override public init() {
        self.manager = CLLocationManager()
        super.init()

        self.manager.delegate = self

    }

    public func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.delegate?.didUpdateLocation(locations: locations.map { PSSLocation($0) })
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.delegate?.didFailWithError(error: error)
    }

    private weak var delegate: LocationProvidingDelegate?

    public func setDelegate(delegate: (any LocationProvidingDelegate)?) {
        self.delegate = delegate
    }
}

public extension PSSLocation {
    init(_ location: CLLocation) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
