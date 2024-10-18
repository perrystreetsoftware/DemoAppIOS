import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents

public struct CountryListBottomView: View {
    @EnvironmentObject var context: CountryListContext

    public var body: some View {
        CountryListButton(isLoading: context.listUiState.isLoading,
                          onItemTapped: context.onButtonTapped)
        Button {
            context.onFailOtherTapped?()
        } label: {
            L10n.Ui.failOtherTitle.text
        }
    }
}
