import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents
import ViewModels

public struct CountryListPage: View {
    private var listUiState: CountryListUiState
    private var onItemTapped: ((Country) -> Void)?
    private var onButtonTapped: (() -> Void)?
    private var onRefreshLocationTap: (() -> Void)?
    private var onFailOtherTapped: (() -> Void)?

    public init(listUiState: CountryListUiState,
                onItemTapped: ((Country) -> Void)? = nil,
                onButtonTapped: (() -> Void)? = nil,
                onRefreshLocationTap: (() -> Void)?,
                onFailOtherTapped: (() -> Void)? = nil) {
        self.listUiState = listUiState
        self.onItemTapped = onItemTapped
        self.onButtonTapped = onButtonTapped
        self.onRefreshLocationTap = onRefreshLocationTap
        self.onFailOtherTapped = onFailOtherTapped
    }

    @ViewBuilder
    func yourLocation() -> some View {
        Button {
            onRefreshLocationTap?()
        } label: {
            listUiState.yourLocation.uiString.text
        }
    }

    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: listUiState.isLoading)
            VStack {
                CountryListView(continentList: listUiState.continents, onItemTapped: { country in
                    self.onItemTapped?(country)
                })
                ServerStatusView(serverStatus: listUiState.serverStatus)
                CountryListButton(isLoading: listUiState.isLoading,
                                  onItemTapped: onButtonTapped)
                Button {
                    onFailOtherTapped?()
                } label: {
                    L10n.Ui.failOtherTitle.text
                }
                
                yourLocation()
            }
        }
    }
}

struct CountryListPage_Previews: PreviewProvider {
    static var previews: some View {
        let continents = [Continent(name: "North America", countries: [Country(regionCode: "es")])]

        CountryListPage(listUiState: CountryListUiState(continents:continents), onRefreshLocationTap: {})
    }
}
