import Foundation
import Quick
import Combine
import CombineExpectations
import CombineSchedulers

// swiftlint:disable pss_forced_try
@discardableResult
public func waitCompletion<Output, Error>(_ publisher: AnyPublisher<Output, Error>,
                                      scheduler: TestSchedulerOf<DispatchQueue>? = nil,
                                      timeout: TimeInterval = 1.0) -> Subscribers.Completion<Error> {
    let recorder = publisher.record()
    scheduler?.advance()
    return try! QuickSpec.current.wait(for: recorder.completion, timeout: timeout)
}

@discardableResult
public func waitCompletion<Output, Error>(_ recorder: Recorder<Output, Error>,
                                          scheduler: TestSchedulerOf<DispatchQueue>? = nil,
                                          timeout: TimeInterval = 1.0) -> Subscribers.Completion<Error> {
    scheduler?.advance()
    return try! QuickSpec.current.wait(for: recorder.completion, timeout: timeout)
}

@discardableResult
public func waitNext<Output, Error>(_ recorder: Recorder<Output, Error>, count: Int, timeout: TimeInterval = 1.0) -> [Output] {
    return try! QuickSpec.current.wait(for: recorder.next(count), timeout: timeout)
}

@discardableResult
public func waitForNextOne<Output, Error>(_ recorder: Recorder<Output, Error>, timeout: TimeInterval = 1.0) -> Output {
    return try! QuickSpec.current.wait(for: recorder.next(), timeout: timeout)
}

@discardableResult
public func waitNext<Output, Error>(_ publisher: AnyPublisher<Output, Error>, count: Int, timeout: TimeInterval = 1.0) -> [Output] {
    return try! QuickSpec.current.wait(for: publisher.record().next(count), timeout: timeout)
}

@discardableResult
public func waitNext<Output, Error>(_ recorder: Recorder<Output, Error>,
                                    scheduler: TestSchedulerOf<DispatchQueue>? = nil,
                                    timeout: TimeInterval = 1.0) -> Output {
    scheduler?.advance()
    return try! QuickSpec.current.wait(for: recorder.next(), timeout: timeout)
}

@discardableResult
public func waitNext<Output, Error>(_ publisher: AnyPublisher<Output, Error>,
                                    scheduler: TestSchedulerOf<DispatchQueue>? = nil,
                                    timeout: TimeInterval = 1.0) -> Output {
    let recorder = publisher.record()
    scheduler?.advance()
    return try! QuickSpec.current.wait(for: recorder.next(), timeout: timeout)
}
// swiftlint:enable pss_forced_try
