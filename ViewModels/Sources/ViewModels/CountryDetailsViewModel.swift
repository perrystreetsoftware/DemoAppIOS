//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import DomainModels
import Combine
import Swinject
import Logic

public enum CountryDetailsViewModelError: Error, Equatable {
    case countryNotFound
    case unknown

    init(_ logicError: CountryDetailsLogicError) {
        switch logicError {
        case .countryNotFound:
            self = .countryNotFound
        default:
            self = .unknown
        }
    }
}

public class CountryDetailsViewModel: ObservableObject {
    public enum State: Equatable {
        case initial
        case loading
        case loaded(details: CountryDetails)
        case error(error: CountryDetailsViewModelError)

        public var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }

    @Published public var state: State = .initial

    private let country: Country
    private let logic: CountryDetailsLogic
    private var cancellables = Set<AnyCancellable>()

    public init(country: Country, logic: CountryDetailsLogic) {
        self.country = country
        self.logic = logic

        onPageLoaded()
    }

    private func onPageLoaded() {
        logic.getDetails(country: country)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            }, receiveOutput: { [weak self] details in
                self?.state = .loaded(details: details)
            }, receiveCancel: { [weak self] in
                self?.state = .initial
            }).sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .error(error: CountryDetailsViewModelError(error))
                case .finished:
                    break
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }

}
