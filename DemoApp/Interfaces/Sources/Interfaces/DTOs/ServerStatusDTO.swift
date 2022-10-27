//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation

public struct ServerStatusDTO: Codable {
    public let ok: Bool
    public let uptime: Float

    public init(ok: Bool, uptime: Float) {
        self.ok = ok
        self.uptime = uptime
    }

    public static let Empty = ServerStatusDTO(ok: false, uptime: 0)
}
