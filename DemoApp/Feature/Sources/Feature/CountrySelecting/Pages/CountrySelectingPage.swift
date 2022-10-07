import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels
import UIComponents

public struct CountrySelectingPage: View {
    @Binding var state: CountrySelectingViewModel.State
    private var onAppear: (() -> Void)?
    private var onItemTapped: ((Country) -> Void)?
    private var onButtonTapped: (() -> Void)?
    
    public init(state: Binding<CountrySelectingViewModel.State>,
                onAppear: (() -> Void)? = nil,
                onItemTapped: ((Country) -> Void)? = nil,
                onButtonTapped: (() -> Void)? = nil) {
        self._state = state
        self.onAppear = onAppear
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
                CountrySelectingButton(isLoading: state.isLoading,
                                       onItemTapped: onButtonTapped)
                .onAppear {
                    onAppear?()
                }
            }
        }
    }
}

struct CountrySelectingPage_Previews: PreviewProvider {
    static var previews: some View {
        let continents = [Continent(name: "North America", countries: [Country(regionCode: "es")])]

        CountrySelectingPage(state: .constant(.loaded(continents:continents)))
    }
}
