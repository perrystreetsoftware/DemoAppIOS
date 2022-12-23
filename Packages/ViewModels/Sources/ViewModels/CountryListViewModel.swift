//
//  CountryListViewModel.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Combine
import DomainModels
import Logic

public final class CountryListViewModel: ObservableObject {
    public struct UiState: Equatable {
        public let continents: [Continent]
        public let isLoading: Bool
        public let isLoaded: Bool
        public let serverStatus: ServerStatus?

        public init(continents: [Continent] = [],
                    isLoading: Bool = false,
                    isLoaded: Bool = false,
                    serverStatus: ServerStatus? = nil) {
            self.continents = continents
            self.isLoading = isLoading
            self.isLoaded = isLoaded
            self.serverStatus = serverStatus
        }

        public func copy(
            continents: [Continent]? = nil,
            isLoading: Bool? = nil,
            isLoaded: Bool? = nil,
            serverStatus: ServerStatus? = nil
        ) -> UiState {
            return UiState(
                continents: continents ?? self.continents,
                isLoading: isLoading != nil ? (isLoading ?? false) : self.isLoading,
                isLoaded: isLoaded != nil ? (isLoaded ?? false) : self.isLoaded,
                serverStatus: serverStatus != nil ? serverStatus : self.serverStatus
            )
        }
    }

    @Published public var state: UiState = UiState()
    @Published public var navigationDestination: Country?
    @Published public var error: CountryListError? = nil

    private var cancellables = Set<AnyCancellable>()
    private let logic: CountryListLogic
    private let serverStatusLogic: ServerStatusLogic

    public init(logic: CountryListLogic, serverStatusLogic: ServerStatusLogic) {
        self.logic = logic
        self.serverStatusLogic = serverStatusLogic

        logic.$continents
            .dropFirst()
            .sink(receiveValue: { [weak self] continents in
                guard let self = self else { return }

                self.state = self.state.copy(continents: continents)
            })
            .store(in: &cancellables)

        onPageLoaded()
    }

    private func onPageLoaded() {
        guard state.isLoaded == false else { return }

        logic.reload()
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let self = self else { return }

                self.state = self.state.copy(isLoading: true)
            }, receiveCancel: { [weak self] in
                guard let self = self else { return }

                self.state = self.state.copy(isLoading: false)
            }).sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case .failure(let error):
                    self.error = error
                    self.state = self.state.copy(isLoading: false)
                case .finished:
                    self.state = self.state.copy(isLoading: false, isLoaded: true)

                }
            }, receiveValue: { _ in
            })
            .store(in: &cancellables)

        serverStatusLogic.$serverStatus.sink { [weak self] serverStatus in
            guard let self = self else { return }

            self.state = self.state.copy(serverStatus: serverStatus)
        }.store(in: &cancellables)

        serverStatusLogic.reload().sink { _ in
        } receiveValue: { _ in
        }.store(in: &cancellables)

    }

    public func onButtonTapped() {
        logic.getForbiddenApi()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    break
                }
            },
                  receiveValue: { _ in })
            .store(in: &cancellables)
    }

    public func onCountrySelected(country: Country) {
        logic.canAccessCountry(country: country)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.navigationDestination = nil
                    self.error = error
                case .finished:
                    self.navigationDestination = country
                }
            },
                  receiveValue: { _ in })
            .store(in: &cancellables)
    }

    public func onFailOtherTapped() {
        self.error = .other
    }

    public func navigateToRandomCountry() {
        if let country = logic.getRandomCountry() {
            onCountrySelected(country: country)
        }
    }
}
