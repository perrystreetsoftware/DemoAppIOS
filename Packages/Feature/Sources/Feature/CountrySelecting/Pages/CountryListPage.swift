import SwiftUI
import Foundation
import Utils
import DomainModels
import UIComponents
import ViewModels

public struct CountryListPage: View {
    @EnvironmentObject var context: CountryListContext
    
    public var body: some View {
        ZStack {
            CountryListOverlay()
            VStack {
                CountryListView()
                ServerStatus()
                CountryListBottomView()
            }
        }
    }
}

struct CountryListPage_Preview_CA: PreviewProvider {
    static var previews: some View {
        CountryListPage().environmentObject(getContextForPreview(regionCode: "ca"))
    }
}

struct CountryListPage_Preview_US: PreviewProvider {
    static var previews: some View {
        CountryListPage().environmentObject(getContextForPreview(regionCode: "us"))
    }
}

func getContextForPreview(regionCode: String) -> CountryListContext {
    return CountryListContext(listUiState: CountryListViewModel.UiState(continents: [Continent(name: "North America", countries: [Country(regionCode: regionCode)])]))
}
