//
//  ContentView.swift
//  Shared
//
//  Created by Eric Silverberg on 9/10/22.
//

import SwiftUI
import UIComponents
import BusinessLogic
import Utils

struct ContentView: View {
    @Inject var viewModel: CountrySelectingViewModel

    var body: some View {
        CountrySelectingAdapter(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
