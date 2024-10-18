import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents

public struct CountryListOverlay: View {
    @EnvironmentObject var context: CountryListContext

    public var body: some View {
        ProgressIndicator(isLoading: context.listUiState.isLoading)
    }
}
