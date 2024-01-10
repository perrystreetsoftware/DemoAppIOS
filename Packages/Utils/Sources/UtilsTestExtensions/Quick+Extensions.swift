import Foundation
import Quick
import Combine
import CombineExpectations
import CombineSchedulers

// swiftlint:disable pss_forced_try
public func runAfterBeforeEach(_ closure: @escaping BeforeExampleClosure) {
    QuickSpec.justBeforeEach(closure)
}

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

/*
 Quick and Nimble doesn't has support to async/await methods, this is an workaround that will be used until something offical be released.
 More info please check this thread:  https://github.com/Quick/Quick/issues/1084
 */

//public func asyncIt(_ description: String, flags: FilterFlags = [:], file: FileString = #file, line: UInt = #line, closure: @MainActor @escaping () async throws -> Void) {
//    it(description, flags: flags, file: file, line: line) {
//        var thrownError: Error?
//        let errorHandler = { thrownError = $0 }
//        let expectation = QuickSpec.current.expectation(description: description)
//
//        Task {
//            do {
//                try await closure()
//            } catch {
//                errorHandler(error)
//            }
//
//            expectation.fulfill()
//        }
//
//        QuickSpec.current.wait(for: [expectation], timeout: 60)
//
//        if let error = thrownError {
//            XCTFail("Async error thrown: \(error)")
//        }
//    }
//}

public func asyncBeforeEach(_ closure: @MainActor @escaping (ExampleMetadata) async -> Void) {
    QuickSpec.beforeEach({ exampleMetadata in
        let expectation = QuickSpec.current.expectation(description: "asyncBeforeEach")
        Task {
            await closure(exampleMetadata)
            expectation.fulfill()
        }
        QuickSpec.current.wait(for: [expectation], timeout: 60)
    })
}

public func asyncAfterEach(_ closure: @MainActor @escaping (ExampleMetadata) async -> Void) {
    QuickSpec.afterEach({ exampleMetadata in
        let expectation = QuickSpec.current.expectation(description: "asyncAfterEach")
        Task {
            await closure(exampleMetadata)
            expectation.fulfill()
        }
        QuickSpec.current.wait(for: [expectation], timeout: 60)
    })
}
