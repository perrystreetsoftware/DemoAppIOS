import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents
import ViewModels

public struct CountrySelectingPage: View {
    @Binding var state: CountrySelectingViewModel.UiState
    private var onItemTapped: ((Country) -> Void)?
    private var onButtonTapped: (() -> Void)?
    
    public init(state: Binding<CountrySelectingViewModel.UiState>,
                onItemTapped: ((Country) -> Void)? = nil,
                onButtonTapped: (() -> Void)? = nil) {
        self._state = state
        self.onItemTapped = onItemTapped
        self.onButtonTapped = onButtonTapped
    }
    
    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: state.isLoading)
            VStack {
                CountrySelectingList(continentList: state.continents, onItemTapped: { country in
                    self.onItemTapped?(country)
                })
                VStack {
                    if state.serverStatus?.success == true {
                        HStack {
                            Text(L10n.Ui.serverStatusOk)
                            Circle()
                                .fill(.green)
                                .frame(width: 10, height: 10)
                        }
                    } else {
                        HStack {
                            Text(L10n.Ui.serverStatusNotOk)
                            Circle()
                                .fill(.orange)
                                .frame(width: 10, height: 10)
                        }
                    }
                }.font(.caption).padding(5)
                CountrySelectingButton(isLoading: state.isLoading,
                                       onItemTapped: onButtonTapped)
            }
        }
    }
}

struct CountrySelectingPage_Previews: PreviewProvider {
    static var previews: some View {
        let continents = [Continent(name: "North America", countries: [Country(regionCode: "es")])]

        CountrySelectingPage(state: .constant(CountrySelectingViewModel.UiState(continents:continents)))
    }
}
