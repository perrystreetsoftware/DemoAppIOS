//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/26/22.
//

import Foundation
import DomainModels
import BusinessLogic
import Combine

public class CountrySelectingErrorAdapter: ObservableObject {
    @Published var error: CountrySelectingViewModelError? = nil
    private var viewModel: CountrySelectingViewModel

    init(viewModel: CountrySelectingViewModel) {
        self.viewModel = viewModel

        viewModel.events.filter { event -> Bool in
            if case .error = event {
                return true
            } else {
                return false
            }
        }
        .map({ event -> CountrySelectingViewModelError? in
            if case .error(let innerError) = event {
                return innerError
            } else {
                return nil
            }
        })
        .assign(to: &$error)
    }
}
