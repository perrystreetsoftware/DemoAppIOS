import Combine

public extension Subscribers.Completion {
    var isFinished: Bool {
        switch self {
        case .finished:
            return true
            
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        switch self {
        case .finished:
            return false
            
        case .failure:
            return true
        }
    }
    
    var error: Failure? {
        switch self {
        case .finished:
            return nil
            
        case .failure(let error):
            return error
        }
    }
}
