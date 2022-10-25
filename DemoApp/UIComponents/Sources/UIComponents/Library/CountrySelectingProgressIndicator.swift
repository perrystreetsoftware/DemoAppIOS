import SwiftUI
import Foundation
import Utils

public struct ProgressIndicator: View {
    var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public var body: some View {
        VStack {
            Text(L10n.Ui.loading)
            ProgressView()
        }.isHidden(isLoading == false)
    }
}

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProgressIndicator(isLoading: true)
            ProgressIndicator(isLoading: false)
        }
        .environment(\.locale, .init(identifier: "es"))
    }
}
