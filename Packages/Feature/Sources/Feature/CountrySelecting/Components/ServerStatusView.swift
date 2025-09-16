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
        VStack {
            if serverStatus?.success == true {
                HStack {
                    L10n.Ui.serverStatusOk.text
                    Circle()
                        .fill(.green)
                        .frame(width: 10, height: 10)
                }
            } else {
                HStack {
                    L10n.Ui.serverStatusNotOk.text
                    Circle()
                        .fill(.orange)
                        .frame(width: 10, height: 10)
                }
            }
        }.font(.caption).padding(5)
    }
}
