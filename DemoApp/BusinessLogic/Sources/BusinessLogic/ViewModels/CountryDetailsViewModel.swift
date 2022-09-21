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

    public func build(country: CountryUIModel) -> CountryDetailsViewModel {
        return CountryDetailsViewModel(country: country,
                                       logic: resolver.resolve(CountryDetailsLogic.self)!)
    }
}

public class CountryDetailsViewModel {
    public enum State {
        case initial
        case loading

        public var isLoading: Bool {
            self == .loading
        }
    }

    @Published public private(set) var state: State = .initial
    @Published public var details: CountryDetailsUIModel? = nil

    public let country: CountryUIModel
    private let logic: CountryDetailsLogic
    private var cancellables = Set<AnyCancellable>()

    public init(country: CountryUIModel, logic: CountryDetailsLogic) {
        self.country = country
        self.logic = logic
    }

    public func onPageLoaded() {
        logic.getDetails(country: country)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            }, receiveCancel: { [weak self] in
                self?.state = .initial
            }).sink(receiveCompletion: { [weak self] _ in
                self?.state = .initial
            }, receiveValue: { details in
                self.details = details
            })
            .store(in: &cancellables)
    }

}
