import Combine
import Foundation

public extension Publisher {
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    static func error(_ error: Failure) -> AnyPublisher<Output, Failure> {
        Fail(error: error)
            .eraseToAnyPublisher()
    }
}
