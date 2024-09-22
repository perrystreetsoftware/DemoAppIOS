//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/19/22.
//

import Foundation
import Interfaces
import CombineSchedulers
import FrameworkProviderProtocols

public class AppSchedulerProvider: AppSchedulerProviding {
    public var mainScheduler: AnySchedulerOf<DispatchQueue> {
        DispatchQueue.main.eraseToAnyScheduler()
    }
}
