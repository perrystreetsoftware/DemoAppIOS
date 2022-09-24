//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Combine
import DomainModels

public enum CountrySelectingViewModelError: Error, Identifiable {
    public var id: Self { self }

    case forbidden
    case unknown

    init(_ logicError: CountrySelectingLogicError) {
        switch logicError {
        case .forbidden:
            self = .forbidden
        default:
            self = .unknown
        }
    }
}

public final class CountrySelectingViewModel: ObservableObject {
    public enum State {
        case initial
        case loading

        public var isLoading: Bool {
            self == .loading
        }
    }

    public enum Event {
        case itemTapped(country: Country)
        case error(error: CountrySelectingViewModelError)
    }

    @Published public private(set) var state: State = .initial
    @Published public private(set) var continents: [Continent]

    private var eventEmitter = PassthroughSubject<Event, Never>()
    public lazy var events: AnyPublisher<Event, Never> = eventEmitter.eraseToAnyPublisher()

    private var cancellables = Set<AnyCancellable>()
    private let logic: CountrySelectingLogic

    public init(logic: CountrySelectingLogic) {
        self.logic = logic
        self.continents = logic.continents

        logic.$continents.assign(to: &$continents)
    }

    public func onPageLoaded() {
        guard continents.count == 0 else { return }

        logic.reload()
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            }, receiveCancel: { [weak self] in
                self?.state = .initial
            }).sink(receiveCompletion: { [weak self] _ in
                self?.state = .initial
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)
    }

    public func onItemTapped(country: Country) {
        eventEmitter.send(Event.itemTapped(country: country))
    }

    public func onButtonTapped() {
        logic.getForbiddenApi()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.eventEmitter.send(.error(error: CountrySelectingViewModelError(error)))
                case .finished:
                    break
                }
            },
                  receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
