//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import CombineSchedulers

public protocol AppSchedulerProviding {
    var mainScheduler: AnySchedulerOf<DispatchQueue> { get }
}
