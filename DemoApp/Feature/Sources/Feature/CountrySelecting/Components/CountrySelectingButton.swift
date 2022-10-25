import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels
import UIComponents

public struct CountrySelectingButton: View {
    private var isLoading: Bool
    private var onItemTapped: (() -> Void)?

    public init(isLoading: Bool,
                onItemTapped: (() -> Void)? = nil) {
        self.isLoading = isLoading
        self.onItemTapped = onItemTapped
    }

    public var body: some View {
        Button {
            onItemTapped?()
        } label: {
            Text(L10n.refreshButtonTitle)
        }.disabled(isLoading)

    }
}

struct CountrySelectingButton_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingButton(isLoading: false)
    }
}
