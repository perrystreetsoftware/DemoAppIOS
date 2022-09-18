import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingPage: View {
    @ObservedObject var state: CountrySelectingUIState
    private var onAppear: (() -> Void)?
    private var onItemTapped: ((Country) -> Void)?
    
    public init(state: CountrySelectingUIState,
                onAppear: (() -> Void)? = nil,
                onItemTapped: ((Country) -> Void)? = nil) {
        self.state = state
        self.onAppear = onAppear
        self.onItemTapped = onItemTapped
    }
    
    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: $state.viewModelState.map { $0.isLoading })
            CountrySelectingList(continentList: $state.continents, onItemTapped: { country in
                self.onItemTapped?(country)
            })
            .onAppear {
                onAppear?()
            }
        }
    }
}

struct CountrySelectingPage_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingPage(state: CountrySelectingUIState(continents: [Continent(name: "Africa", countries: [Country(regionCode: "ng")])], state: .initial))
    }
}
