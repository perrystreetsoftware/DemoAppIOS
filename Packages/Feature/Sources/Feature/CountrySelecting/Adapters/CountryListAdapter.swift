//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import SwiftUI
import Utils
import Combine
import UIComponents
import DomainModels
import ViewModels
import Waypoint

public struct CountryListAdapter: View {
    @InjectStateObject private var viewModel: CountryListViewModel
    @Environment(WaypointNavigator.self) private var navigator

    public init() {}

    public var body: some View {
        CountryListPage(listUiState: viewModel.state, onItemTapped: { country in
            viewModel.onCountrySelected(country: country)
        }, onButtonTapped: {
            viewModel.onButtonTap()
        }, onRefreshLocationTap: {
            viewModel.onRefreshLocationTap()
        }, onFailOtherTapped: {
            viewModel.onFailOtherTap()
        })
        .onReceive(viewModel.$navigationDestination, perform: { country in
            guard let country = country else { return }

            navigator.navigate(to: CountryDetailsAdapter(regionCode: country.regionCode), mode: .present(.sheet))

            viewModel.navigationDestination = nil
        })
        .pss_notify(item: $viewModel.error, alertBuilder: {
            $0.asFloatingAlert(viewModel: viewModel, onAboutThisAppSelected: {
                navigator.switchTab(to: AppTab.about)
            })
        })
    }
}
