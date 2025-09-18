//
//  StatusBallView.swift
//  Feature
//
//  Created by Eric Silverberg on 9/17/25.
//

import SwiftUI

public struct StatusBallView: View {
    private let isSuccess: Bool

    public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }

    public var body: some View {
        VStack {
            if isSuccess == true {
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
