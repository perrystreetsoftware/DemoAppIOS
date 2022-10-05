//
//  File.swift
//  
//
//  Created by Matheus on 05/10/22.
//

import Foundation

public struct ProfileGridCellUIModel: Equatable, Identifiable, Hashable {
    public var index: Int
    public var remoteId: Int
    public var name: String?
    public var photoUrlRequest: URLRequest?
    public var isNewMember: Bool
    public var isTraveling: Bool
    public var isOnline: Bool
    public var isRecent: Bool
    public var hasAnyUnreadMessages: Bool
    public var hasAnyImages: Bool
    
    public var id: Int {
        return self.index
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
    
    public init(user: PSSUser, index: Int, photoUrlRequest: URLRequest? = nil) {
        self.remoteId = user.remoteId
        self.name = user.name
        self.isNewMember = user.isNewMember
        self.isTraveling = user.isTraveling
        self.isOnline = user.isOnline
        self.isRecent = user.isRecent
        self.hasAnyUnreadMessages = user.hasAnyUnreadMessages
        self.hasAnyImages = user.hasAnyImages
        self.photoUrlRequest = photoUrlRequest
        self.index = index
    }
}

public struct PSSUser {
    public init(remoteId: Int, name: String? = nil, isNewMember: Bool, isTraveling: Bool, isOnline: Bool, isRecent: Bool, hasAnyUnreadMessages: Bool, hasAnyImages: Bool) {
        self.remoteId = remoteId
        self.name = name
        self.isNewMember = isNewMember
        self.isTraveling = isTraveling
        self.isOnline = isOnline
        self.isRecent = isRecent
        self.hasAnyUnreadMessages = hasAnyUnreadMessages
        self.hasAnyImages = hasAnyImages
    }
    
    public var remoteId: Int
    public var name: String?
    public var isNewMember: Bool
    public var isTraveling: Bool
    public var isOnline: Bool
    public var isRecent: Bool
    public var hasAnyUnreadMessages: Bool
    public var hasAnyImages: Bool
}

extension PSSUser {
    static func stub(id: Int) -> PSSUser {
        return PSSUser(remoteId: id, isNewMember: false, isTraveling: false, isOnline: true, isRecent: false, hasAnyUnreadMessages: false, hasAnyImages: true)
    }
}
