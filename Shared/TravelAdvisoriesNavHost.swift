//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Feature
import SwiftUI
import Waypoint

public struct TravelAdvisoriesNavHost: View {
    public init() {}

    public var body: some View {
        WaypointTabView(tabs: AppTab.allCases.map { tab in
            RootTab(id: tab) { rootView(for: tab) }
        })
    }

    @ViewBuilder private func rootView(for tab: AppTab) -> some View {
        switch tab {
        case .countries:
            CountryListAdapter()
        case .about:
            AboutAdapter()
        }
    }
}
