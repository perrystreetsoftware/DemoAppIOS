//
//  File.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Combine
import DomainModels

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
}
