//
//  TimeAdvancingFactory.swift
//
//
//  Created by Eric Silverberg on 9/22/24.
//

import Foundation
import Interfaces
import InterfaceMocks
import Swinject
import SwinjectAutoregistration

final public class TimeAdvancingFactory {
    private let scheduler: MockAppSchedulerProviding
    private var timeInterval: TimeInterval?

    @discardableResult public init(_ container: Container) {
        self.scheduler = container~>

        self.scheduler.useTestMainScheduler = true
    }

    @discardableResult public func advance(by timeInterval: TimeInterval) -> Self {
        self.timeInterval = timeInterval

        return self
    }

    @discardableResult public func save() -> Self {
        if let timeInterval {
            self.scheduler.testScheduler.advance(by: .seconds(timeInterval))
        } else {
            self.scheduler.testScheduler.advance()
        }

        return self
    }
}

public extension Container {
    func tick() {
        TimeAdvancingFactory(self).save()
    }

    func tick(by timeInterval: TimeInterval) {
        TimeAdvancingFactory(self).advance(by: timeInterval).save()
    }
}
