import Foundation
import AVFoundation
import Combine
import Interfaces

final public class CameraAudioAndVideoPermissionRepository {
    private let api: CameraAudioAndVideoPermissionsApiImplementing
    
    public init(api: CameraAudioAndVideoPermissionsApiImplementing) {
        self.api = api
    }
    
    public func authorizationStatus(for type: AVMediaType) -> AVAuthorizationStatus {
        return api.authorizationStatus(for: type)
    }

    public func requestAccess(for type: AVMediaType) -> AnyPublisher<Bool, Never> {
        Deferred {
            Future<Bool, Never> { promise in
                self.api.requestAccess(for: type, handler: { result in
                    promise(.success(result))
                })
            }
        }.eraseToAnyPublisher()
    }
}
