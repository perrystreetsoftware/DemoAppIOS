//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import SwiftUI
import BusinessLogic
import Utils

public struct CountrySelectingAdapter: View {
    @Inject var viewModel: CountrySelectingViewModel

    public init() {
    }

    public var body: some View {
        CountrySelectingPage(state: CountrySelectingUIState(viewModel: viewModel)) {
            viewModel.onAppear()
        }
    }
}
