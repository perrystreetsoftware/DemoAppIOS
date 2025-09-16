import Foundation
import FrameworkProviderProtocols
import Combine
import FrameworkProviderProtocolModels

public enum MockLocationProviderError: Error {
    case denied
}

public final class MockLocationProvider: LocationProviding {
    public static let MockDelay: TimeInterval = 1.0

    weak var delegate: LocationProvidingDelegate?
    public let scheduler: AppSchedulerProviding
    public var locationCancellable: AnyCancellable?
    public var nextLocation: PSSLocation?
    public var nextError: Error?

    public init(scheduler: AppSchedulerProviding) {
        self.scheduler = scheduler
    }

    public var authorizationStatus: LocationAuthorizationStatus = .notDetermined

    public func requestWhenInUseAuthorization() {
    }

    public func startUpdatingLocation() {
        locationCancellable =
            Publishers.Timer(every: .seconds(Self.MockDelay),
                             scheduler: self.scheduler.mainScheduler)
            .autoconnect()
            .first()
            .sink(receiveValue: { [weak self] (_) in
                guard let self = self else { return }

                if authorizationStatus == .denied {
                    self.delegate?.didFailWithError(error: MockLocationProviderError.denied)
                } else if let nextError {
                    self.delegate?.didFailWithError(error: nextError)
                } else if let nextLocation {
                    self.delegate?.didUpdateLocation(locations: [nextLocation])
                } else {
                    self.delegate?.didUpdateLocation(locations: [self.generateRandomLocation()])
                }
            })
    }
    
    public func stopUpdatingLocation() {
    }
    
    public func setDelegate(delegate: (any LocationProvidingDelegate)?) {
        self.delegate = delegate
    }

    private func generateRandomLocation() -> PSSLocation {
        if let location = nextLocation {
            self.nextLocation = nil

            return location
        } else {
            let latitude = Double.random(in: -90..<90)
            let longitude = Double.random(in: -180..<180)

            return PSSLocation(latitude: latitude, longitude: longitude)
        }
    }
}
