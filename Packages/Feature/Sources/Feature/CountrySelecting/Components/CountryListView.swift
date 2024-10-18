import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents

public struct CountryListView: View {
    @EnvironmentObject var context: CountryListContext

    public var body: some View {
        List {
            ForEach(context.listUiState.continents, id: \.self) { continent in
                Section(header: continent.titleTextView) {
                    ForEach(continent.countries, id: \.self) { country in
                        country.nameTextView.onTapGesture {
                            self.context.onCountrySelected?(country)
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
        CountryListView().environmentObject(getContextForPreview(regionCode: "ca"))
    }
}
