import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingPage: View {
    var state: Binding<CountrySelectingViewModel.State>
    private var onAppear: (() -> Void)?
    private var onItemTapped: ((Country) -> Void)?
    private var onButtonTapped: (() -> Void)?
    
    public init(state: Binding<CountrySelectingViewModel.State>,
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
            ProgressIndicator(isLoading: state.map({ $0.isLoading }))
            VStack {
                CountrySelectingList(continentList: state.map {
                    return $0.continents
                }, onItemTapped: { country in
                    self.onItemTapped?(country)
                })
                CountrySelectingButton(isLoading: state.map { $0.isLoading },
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
