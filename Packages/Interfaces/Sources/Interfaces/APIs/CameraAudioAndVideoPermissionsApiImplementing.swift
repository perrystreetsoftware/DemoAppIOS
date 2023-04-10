import Foundation
import AVFoundation
import Combine

public protocol CameraAudioAndVideoPermissionsApiImplementing {
    func authorizationStatus(for: AVMediaType) -> AVAuthorizationStatus
    func requestAccess(for: AVMediaType, handler: @escaping (Bool) -> Void)
}
