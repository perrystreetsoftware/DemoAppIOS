import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents

public struct CountryListButton: View {
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
            L10n.Ui.refreshButtonTitle.text
        }.disabled(isLoading)

    }
}

struct CountryListButton_Previews: PreviewProvider {
    static var previews: some View {
        CountryListButton(isLoading: false)
    }
}
