//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/19/22.
//

import Foundation
import Interfaces
import CombineSchedulers

public class AppSchedulerProvider: AppSchedulerProviding {
    public var mainScheduler: AnySchedulerOf<DispatchQueue> {
        DispatchQueue.main.eraseToAnyScheduler()
    }
}
