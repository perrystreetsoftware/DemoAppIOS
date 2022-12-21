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
public struct AboutAdapter: View {
    @StateObject private var viewModel: AboutViewModel

    public init(resolver: Swinject.Resolver = InjectSettings.resolver!) {
        self._viewModel = StateObject(wrappedValue: resolver.resolve(AboutViewModel.self)!)
    }

    public var body: some View {
        return AboutPage()
    }
}
