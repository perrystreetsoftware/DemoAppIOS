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
import DomainModels

/// Adapters convert ViewModels into UIState objects
public struct CountryDetailsAdapter: View {
    @Inject var countryDetailsViewModelBuilder: CountryDetailsViewModelBuilder
    private let country: Country

    public init(country: Country) {
        self.country = country

    }

    public var body: some View {
        let vm = countryDetailsViewModelBuilder.build(country: country)

        return CountryDetailsPage(state: CountryDetailsUIState(viewModel: vm)) {
            vm.onPageLoaded()
        }
    }
}
