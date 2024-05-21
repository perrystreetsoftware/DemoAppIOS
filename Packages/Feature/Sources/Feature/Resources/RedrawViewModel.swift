//
//  File.swift
//  
//
//  Created by perrystreet on 5/14/24.
//

import Foundation
import Combine

final class RedrawViewModel: ObservableObject {

    @Published private var userLastIndex: Int = 0 /* we are not listening to this published inside our view */

    @Published public var isReachingLastUser: Bool = false /* our view is only intersted on this state!*/

    init() {
        $userLastIndex.map { $0 > 90 ? true : false }.removeDuplicates().assign(to: &$isReachingLastUser)
    }

    func onUserAppear(index: Int) {
        userLastIndex = index
    }
}
