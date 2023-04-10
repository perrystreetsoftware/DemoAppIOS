
import Foundation
import Combine
import AVFoundation
import Repositories

public final class GetUserAudioAndVideoPermissionLogic {
    private let repository: CameraAudioAndVideoPermissionRepository
    
    init(repository: CameraAudioAndVideoPermissionRepository) {
        self.repository = repository
    }
    
    public func callAsFunction() -> AnyPublisher<Bool, Never> {
        if authorizationStatusForCameraAndMicrophone() == .authorized {
            return Just(true).eraseToAnyPublisher()
        } else {
            return requestAccessForCameraAndMicrophone()
        }
    }
    
    private func requestAccessForCameraAndMicrophone() -> AnyPublisher<Bool, Never> {
        let zip = self.repository.requestAccess(for: .video).zip(self.repository.requestAccess(for: .audio))
        return zip.map { (videoGranted, audioGranted) in
            videoGranted && audioGranted
        }.eraseToAnyPublisher()
    }

    private func authorizationStatusForCameraAndMicrophone() -> AVAuthorizationStatus {
        switch repository.authorizationStatus(for: .video) {
        case .notDetermined:
            return .notDetermined
        case .restricted, .denied:
            return .denied
        case .authorized:
            switch repository.authorizationStatus(for: .audio) {
            case .notDetermined:
                return .notDetermined
            case .restricted, .denied:
                return .denied
            case .authorized:
                return .authorized
            @unknown default:
                fatalError()
            }
        @unknown default:
            fatalError()
        }
    }
}
