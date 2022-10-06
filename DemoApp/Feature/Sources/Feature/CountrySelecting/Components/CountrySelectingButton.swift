import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingButton: View {
    @Binding private var isLoading: Bool
    private var onItemTapped: (() -> Void)?

    public init(isLoading: Binding<Bool>,
                onItemTapped: (() -> Void)? = nil) {
        self._isLoading = isLoading
        self.onItemTapped = onItemTapped
    }

    public var body: some View {
        Button {
            onItemTapped?()
        } label: {
            Text("Failing Api Call")
        }.isHidden(isLoading)

    }
}

struct CountrySelectingButton_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingButton(isLoading: .constant(false))
    }
}
