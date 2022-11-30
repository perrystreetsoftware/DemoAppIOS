//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import SwiftUI
import Utils
import DomainModels
import ViewModels
import Swinject

/// Adapters convert ViewModels into UIState objects
public struct CountryDetailsAdapter: View {
    @StateObject private var viewModel: CountryDetailsViewModel

    public init(regionCode: String,
                resolver: Swinject.Resolver = InjectSettings.resolver!) {
        let country = Country(regionCode: regionCode)
        self._viewModel = StateObject(wrappedValue: resolver.resolve(CountryDetailsViewModel.self, argument: country)!)
    }

    public var body: some View {
        return CountryDetailsPage(detailsUiState: viewModel.state)
    }
}
