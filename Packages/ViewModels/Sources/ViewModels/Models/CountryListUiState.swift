//
//  UiState.swift
//  ViewModels
//
//  Created by Eric Silverberg on 9/15/25.
//

import DomainModels

public struct CountryListUiState: Equatable {
    public let continents: [Continent]
    public let isLoading: Bool
    public let isLoaded: Bool
    public let yourLocation: LocationUiState
    public let serverStatus: ServerStatus?

    public init(continents: [Continent] = [],
                isLoading: Bool = false,
                isLoaded: Bool = false,
                yourLocation: LocationUiState = .unknown,
                serverStatus: ServerStatus? = nil) {
        self.continents = continents
        self.isLoading = isLoading
        self.isLoaded = isLoaded
        self.yourLocation = yourLocation
        self.serverStatus = serverStatus
    }

    public func copy(
        continents: [Continent]? = nil,
        isLoading: Bool? = nil,
        isLoaded: Bool? = nil,
        yourLocation: LocationUiState? = nil,
        serverStatus: ServerStatus? = nil
    ) -> CountryListUiState {
        return CountryListUiState(
            continents: continents ?? self.continents,
            isLoading: isLoading != nil ? (isLoading ?? false) : self.isLoading,
            isLoaded: isLoaded != nil ? (isLoaded ?? false) : self.isLoaded,
            yourLocation: yourLocation ?? self.yourLocation,
            serverStatus: serverStatus != nil ? serverStatus : self.serverStatus
        )
    }
}
