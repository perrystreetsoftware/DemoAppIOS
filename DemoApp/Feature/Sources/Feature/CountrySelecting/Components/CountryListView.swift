import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents

public struct CountryListView: View {
    var continentList: [Continent]
    private var onItemTapped: ((Country) -> Void)?


    public init(continentList: [Continent], onItemTapped: ((Country) -> Void)? = nil) {
        self.continentList = continentList
        self.onItemTapped = onItemTapped
    }

    public var body: some View {
        List {
            ForEach(continentList, id: \.self) { continent in
                Section(header: continent.titleTextView) {
                    ForEach(continent.countries, id: \.self) { country in
                        country.nameTextView.onTapGesture {
                            self.onItemTapped?(country)
                        }
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationBarTitle(L10n.Ui.countriesTitle.stringValue)
    }
}

extension Continent {
    var titleTextView: Text {
        return name.isEmpty ? L10n.Ui.invalidTitle.text : Text(name)
    }
}

extension Country {
    var nameTextView: Text {
        if let countryName = countryName {
            return Text(countryName)
        } else {
            return L10n.Ui.countryNameUnknownTitle.text
        }
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView(
            continentList:
                [Continent(name: "North America",
                           countries: [Country(regionCode: "us")]),
                 Continent(name: "",
                            countries: [Country(regionCode: "XX")])])
        .environment(\.locale, .init(identifier: "es"))
    }
}
