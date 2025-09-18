//
//  ServerStatus.swift
//  Feature
//
//  Created by Eric Silverberg on 9/15/25.
//

import SwiftUI
import DomainModels
import UIComponents

public struct ServerStatusView: View {
    private let serverStatus: ServerStatus?

    public init(serverStatus: ServerStatus?) {
        self.serverStatus = serverStatus
    }

    public var body: some View {
        StatusBallView(isSuccess: serverStatus?.success == true)
    }
}
