import CoreLocation
import FrameworkProviderProtocols
import Combine
import FrameworkProviderProtocolModels

public final class LocationProvider: NSObject, LocationProviding, CLLocationManagerDelegate {
    public var authorizationStatus: LocationAuthorizationStatus {
        return LocationAuthorizationStatus(manager.authorizationStatus)
    }

    private let manager: CLLocationManager
    private weak var delegate: LocationProvidingDelegate?

    override public init() {
        self.manager = CLLocationManager()
        super.init()

        self.manager.delegate = self

    }

    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.didChangeAuthorization(
            status: LocationAuthorizationStatus(status)
        )
    }

    public func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
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

    public func setDelegate(delegate: (any LocationProvidingDelegate)?) {
        self.delegate = delegate
    }
}

public extension PSSLocation {
    init(_ location: CLLocation) {
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}
