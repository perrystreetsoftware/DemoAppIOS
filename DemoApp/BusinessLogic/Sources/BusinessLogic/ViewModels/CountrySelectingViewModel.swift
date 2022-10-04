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
        case loaded(continents: [Continent])

        public var isLoading: Bool {
            if case .loading = self {
                return true
            }

            return false
        }

        public var isLoaded: Bool {
            if case .loaded = self {
                return true
            }

            return false
        }

        public var continents: [Continent] {
            switch self {
            case .loaded(continents: let continents):
                return continents
            default:
                return []
            }
        }
    }

    public enum Event {
        case itemTapped(country: Country)
        case error(error: CountrySelectingViewModelError)
    }

    @Published public var state: State = .initial

    private var eventEmitter = PassthroughSubject<Event, Never>()
    public lazy var events: AnyPublisher<Event, Never> = eventEmitter.eraseToAnyPublisher()

    private var cancellables = Set<AnyCancellable>()
    private let logic: CountrySelectingLogic

    public init(logic: CountrySelectingLogic) {
        self.logic = logic

        logic.$continents
            .dropFirst()
            .sink(receiveValue: { continents in
                self.state = .loaded(continents: continents)
            })
            .store(in: &cancellables)
    }

    public func onPageLoaded() {
        guard state.isLoaded == false else { return }

        logic.reload()
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.state = .loading
            }, receiveCancel: { [weak self] in
                self?.state = .initial
            }).sink(receiveCompletion: { _ in
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
