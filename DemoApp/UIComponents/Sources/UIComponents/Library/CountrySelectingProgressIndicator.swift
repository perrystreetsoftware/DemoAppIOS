import SwiftUI
import Foundation
import Utils
import BusinessLogic

public struct ProgressIndicator: View {
    var isLoading: Bool

    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }

    public var body: some View {
        VStack {
            Text("Loading...")
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
    }
}
