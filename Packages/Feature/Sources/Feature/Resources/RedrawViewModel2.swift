import Foundation
import Combine

final class RedrawViewModel2: ObservableObject {

    private var userLastIndex = CurrentValueSubject<Int, Never>(0)
    @Published public var isReachingLastUser: Bool = false

    init() {
        userLastIndex.map { $0 > 95 ? true : false }.removeDuplicates().assign(to: &$isReachingLastUser)
    }

    func onUserAppear(index: Int) {
        userLastIndex.send(index)
    }
}
