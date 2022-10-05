//
//  File.swift
//  
//
//  Created by Matheus on 05/10/22.
//

import Foundation

public struct ProfileGridStackUIModel: Equatable, Hashable {
    public static func == (lhs: ProfileGridStackUIModel, rhs: ProfileGridStackUIModel) -> Bool {
        return lhs.profiles == rhs.profiles
    }
    
    public init(profiles: [ProfileGridCellUIModel]) {
        self.profiles = profiles
    }
    
    public var profiles: [ProfileGridCellUIModel]
}
