//
//  CountryListViewModel.swift
//  
//
//  Created by Eric Silverberg on 9/17/22.
//

import Foundation
import Combine
import DomainModels
import FrameworkProviderProtocolModels
import Logic
import DI

@Factory
public final class CountryListViewModel: ObservableObject {
    @Published public var state: CountryListUiState = CountryListUiState()
    @Published public var navigationDestination: Country?
    @Published public var error: CountryListError? = nil
    @Published public var location: PSSLocation? = nil

    private var cancellables = Set<AnyCancellable>()
    private let logic: CountryListLogic
    private let serverStatusLogic: ServerStatusLogic
    private let currentLocationLogic: GetCurrentLocationLogic
    private let getLocationErrorLogic: GetLocationErrorLogic
    private let getNewLocationLogic: GetNewLocationLogic
    private let getNewLocationIfAuthorizedLogic: GetNewLocationIfAuthorizedLogic

    public init(
        logic: CountryListLogic,
        serverStatusLogic: ServerStatusLogic,
        currentLocationLogic: GetCurrentLocationLogic,
        getLocationErrorLogic: GetLocationErrorLogic,
        getNewLocationLogic: GetNewLocationLogic,
        getNewLocationIfAuthorizedLogic: GetNewLocationIfAuthorizedLogic
    ) {
        self.logic = logic
        self.serverStatusLogic = serverStatusLogic
        self.currentLocationLogic = currentLocationLogic
        self.getLocationErrorLogic = getLocationErrorLogic
        self.getNewLocationLogic = getNewLocationLogic
        self.getNewLocationIfAuthorizedLogic = getNewLocationIfAuthorizedLogic

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

        currentLocationLogic().sink { newLocation in
            self.location = newLocation
            self.state = self.state.copy(yourLocation: .location(newLocation))
        }.store(in: &cancellables)

        getNewLocationLogic().sink(receiveCompletion: { _ in
        }, receiveValue: { _ in
        }).store(in: &cancellables)

        getLocationErrorLogic().sink { locationError in
            if locationError != nil {
                self.state = self.state.copy(yourLocation: .error)
            }
        }.store(in: &cancellables)
    }

    public func onButtonTap() {
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

    public func onRefreshLocationTap() {
        getNewLocationIfAuthorizedLogic()
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let self else { return }

                self.state = self.state.copy(yourLocation: .updating)
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { })
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

    public func onFailOtherTap() {
        self.error = .other
    }

    public func navigateToRandomCountry() {
        if let country = logic.getRandomCountry() {
            onCountrySelected(country: country)
        }
    }
}
