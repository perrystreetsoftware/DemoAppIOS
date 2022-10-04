import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingList: View {
    @Binding var continentList: [Continent]
    private var onItemTapped: ((Country) -> Void)?


    public init(continentList: Binding<[Continent]>, onItemTapped: ((Country) -> Void)? = nil) {
        self._continentList = continentList
        self.onItemTapped = onItemTapped
    }

    public var body: some View {
        List {
            ForEach(continentList, id: \.self) { continent in
                Section(header: Text(continent.name)) {
                    ForEach(continent.countries, id: \.self) { country in
                        Text(country.countryName ?? "Unknown").onTapGesture {
                            self.onItemTapped?(country)
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle(L10n.countriesTitle)
    }
}

struct CountrySelectingList_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingList(continentList: .constant([Continent(name: "North America", countries: [Country(regionCode: "us")])]))
    }
}
