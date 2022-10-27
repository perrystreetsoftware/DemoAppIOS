import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents
import ViewModels

public struct CountryListPage: View {
    private var listUiState: CountryListViewModel.UiState
    private var onItemTapped: ((Country) -> Void)?
    private var onButtonTapped: (() -> Void)?
    
    public init(listUiState: CountryListViewModel.UiState,
                onItemTapped: ((Country) -> Void)? = nil,
                onButtonTapped: (() -> Void)? = nil) {
        self.listUiState = listUiState
        self.onItemTapped = onItemTapped
        self.onButtonTapped = onButtonTapped
    }
    
    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: listUiState.isLoading)
            VStack {
                CountryListView(continentList: listUiState.continents, onItemTapped: { country in
                    self.onItemTapped?(country)
                })
                VStack {
                    if listUiState.serverStatus?.success == true {
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
                CountryListButton(isLoading: listUiState.isLoading,
                                       onItemTapped: onButtonTapped)
            }
        }
    }
}

struct CountryListPage_Previews: PreviewProvider {
    static var previews: some View {
        let continents = [Continent(name: "North America", countries: [Country(regionCode: "es")])]

        CountryListPage(state: CountryListViewModel.UiState(continents:continents))
    }
}
