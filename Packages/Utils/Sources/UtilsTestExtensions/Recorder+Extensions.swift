import Foundation
import CombineExpectations

public extension Recorder {
    // swiftlint:disable pss_forced_try
    var lastElement: Input {
        try! self.availableElements.get().last!
    }
    var elementCount: Int {
        try! self.availableElements.get().count
    }
    
    var allElements: [Recorder.Input] {
        try! self.availableElements.get()
    }

    var allElementsDescription: [String] {
        try! self.availableElements.get().map { ($0 as? CustomStringConvertible)?.description ?? "nil" }
    }
    // swiftlint:enable pss_forced_try
}
