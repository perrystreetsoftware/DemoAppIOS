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
import ViewModels

/// Adapters convert ViewModels into UIState objects
public struct CountryDetailsAdapter: View {
    @ObservedObject private var viewModel: CountryDetailsViewModel

    public init(viewModel: CountryDetailsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        return CountryDetailsPage(state: $viewModel.state)
    }
}
