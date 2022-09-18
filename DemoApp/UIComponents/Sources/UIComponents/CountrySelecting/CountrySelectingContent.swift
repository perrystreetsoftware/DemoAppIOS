import SwiftUI
import Foundation
import Utils
import BusinessLogic
import DomainModels

public struct CountrySelectingContent: View {
    @Binding var continentList: [ContinentUIModel]

    public init(continentList: Binding<[ContinentUIModel]>) {
        self._continentList = continentList
    }

    public var body: some View {
        List {
            ForEach(continentList, id: \.self) { continent in
                Section(header: Text(continent.name)) {
                    ForEach(continent.countries, id: \.self) { country in
                        NavigationLink(destination: CountryDetailsAdapter(country: country)) {
                            Text(country.countryName ?? "Unknown")
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle("Countries")
    }
}

struct CountrySelectingContent_Previews: PreviewProvider {
    static var previews: some View {
        CountrySelectingContent(continentList: .constant([ContinentUIModel(name: "Africa", countries: [CountryUIModel(regionCode: "ng")])]))
    }
}
