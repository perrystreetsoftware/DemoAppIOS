import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents

public struct ServerStatus: View {
    @EnvironmentObject var context: CountryListContext

    public var body: some View {
        VStack {
            if context.listUiState.serverStatus?.success == true {
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
