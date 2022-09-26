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
import Combine

public struct CountrySelectingAdapter: View {
    private let viewModel: CountrySelectingViewModel
    @ObservedObject private var viewNavigator: CountrySelectingViewNavigator

    public init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel
        viewNavigator = CountrySelectingViewNavigator(viewModel: viewModel)
    }

    public var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: viewNavigator.buildView(),
                    isActive: $viewNavigator.nextCountryToReach.mappedToBool(),
                    label: {
                        EmptyView()
                    }
                )

                CountrySelectingPage(state: CountrySelectingUIState(viewModel: viewModel), onAppear: {
                    viewModel.onPageLoaded()
                }, onItemTapped: { country in
                    viewModel.onItemTapped(country: country)
                }) {
                    viewModel.onButtonTapped()
                }
            }
        }
    }
}
