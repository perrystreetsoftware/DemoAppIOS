import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels
import UIComponents

public struct CountrySelectingList: View {
    var continentList: [Continent]
    private var onItemTapped: ((Country) -> Void)?


    public init(continentList: [Continent], onItemTapped: ((Country) -> Void)? = nil) {
        self.continentList = continentList
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
        CountrySelectingList(
            continentList:
                [Continent(name: "North America",
                           countries: [Country(regionCode: "us")])]
        )
    }
}
