import SwiftUI
import Foundation
import Utils
import BusinessLogic

public struct ProgressIndicator: View {
    @Binding var isLoading: Bool

    public init(isLoading: Binding<Bool>) {
        self._isLoading = isLoading
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
            ProgressIndicator(isLoading: .constant(true))
            ProgressIndicator(isLoading: .constant(false))
        }
    }
}
