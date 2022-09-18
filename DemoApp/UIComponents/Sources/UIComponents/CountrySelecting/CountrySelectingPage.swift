import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingPage: View {
    @ObservedObject var state: CountrySelectingUIState
    private var onAppear: (() -> Void)?
    
    public init(state: CountrySelectingUIState,
                onAppear: (() -> Void)? = nil) {
        self.state = state
        self.onAppear = onAppear
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                ProgressIndicator(isLoading: $state.state.map { $0.isLoading })
                CountrySelectingContent(continentList: $state.continents)
                    .onAppear {
                        onAppear?()
                    }
            }
        }
    }
}

struct CountrySelectingPage_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingPage(state: CountrySelectingUIState(continents: [ContinentUIModel(name: "Africa", countries: [CountryUIModel(regionCode: "ng")])], state: .initial))
    }
}
