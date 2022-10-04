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

public final class CountryDetailsViewModelBuilder {
    private var resolver: Swinject.Resolver

    init(resolver: Swinject.Resolver) {
        self.resolver = resolver
    }

    public func build(country: Country) -> CountryDetailsViewModel {
        return CountryDetailsViewModel(country: country,
                                       logic: resolver.resolve(CountryDetailsLogic.self)!)
    }
}

public enum CountryDetailsViewModelError: Error {
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

public class CountryDetailsViewModel {
    public enum State: Equatable {
        case initial
        case loading
        case error(error: CountryDetailsViewModelError)

        public var isLoading: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }

        public static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.initial, .initial):
                return true
            case (.loading, .loading):
                return true
            case (.error, .error):
                return true
            default:
                return false
            }
        }
    }

    @Published public private(set) var state: State = .initial
    @Published public var details: CountryDetails? = nil

    public let country: Country
    private let logic: CountryDetailsLogic
    private var cancellables = Set<AnyCancellable>()

    public init(country: Country, logic: CountryDetailsLogic) {
        self.country = country
        self.logic = logic
    }

    public func onPageLoaded() {
        logic.getDetails(country: country)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            }, receiveCancel: { [weak self] in
                self?.state = .initial
            }).sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.state = .error(error: CountryDetailsViewModelError(error))
                case .finished:
                    self?.state = .initial
                }
            }, receiveValue: { details in
                self.details = details
            })
            .store(in: &cancellables)
    }

}
