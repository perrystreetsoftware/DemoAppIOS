import Foundation
import AVFoundation
import Combine
import Interfaces

public final class MockCameraAudioAndVideoPermissionsAPI: CameraAudioAndVideoPermissionsApiImplementing {
    public var mockAuthorizationResult = [AVMediaType: AuthorizationMockType]()

    public enum AuthorizationMockType {
        case approve
        case deny
    }
    
    public var authorizationStatuses = [AVMediaType: AVAuthorizationStatus]()

    public func requestAccess(for type: AVMediaType, handler: @escaping (Bool) -> Void) {

        if let status = authorizationStatuses[type] {
            switch status {
            case .notDetermined:
                break
            case .restricted, .denied:
                handler(false)
            case .authorized:
                handler(true)
            @unknown default:
                break
            }
        }

        switch mockAuthorizationResult[`type`] {
        case .approve, .none:
            authorizationStatuses[type] = .authorized
            handler(true)
        case .deny:
            authorizationStatuses[type] = .denied
            handler(false)
        }
    }

    public func authorizationStatus(for: AVMediaType) -> AVAuthorizationStatus {
        authorizationStatuses[`for`] ?? .notDetermined
    }
}
