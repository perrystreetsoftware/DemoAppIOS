import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingPage: View {
    @ObservedObject var state: CountrySelectingUIState
    private var onAppear: (() -> Void)?
    private var onItemTapped: ((Country) -> Void)?
    private var onButtonTapped: (() -> Void)?
    
    public init(state: CountrySelectingUIState,
                onAppear: (() -> Void)? = nil,
                onItemTapped: ((Country) -> Void)? = nil,
                onButtonTapped: (() -> Void)? = nil) {
        self.state = state
        self.onAppear = onAppear
        self.onItemTapped = onItemTapped
        self.onButtonTapped = onButtonTapped
    }
    
    public var body: some View {
        ZStack {
            ProgressIndicator(isLoading: $state.viewModelState.map { $0.isLoading })
            VStack {
                CountrySelectingList(continentList: $state.continents, onItemTapped: { country in
                    self.onItemTapped?(country)
                })
                CountrySelectingButton(isLoading: $state.viewModelState.map { $0.isLoading },
                                       onItemTapped: onButtonTapped)
                .onAppear {
                    onAppear?()
                }
            }
        }.alert(item: $state.error) { error in
            let uiError = error.uiError

            return Alert(
                title: Text(uiError.title),
                message: Text(uiError.messages.joined(separator: " ")),
                dismissButton: .cancel(Text(L10n.cancelButtonTitle), action: {
                    $state.error.wrappedValue = nil
                })
            )
        }
    }
}

struct CountrySelectingPage_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingPage(state: CountrySelectingUIState(continents: [Continent(name: "Africa", countries: [Country(regionCode: "ng")])], state: .initial))
    }
}
