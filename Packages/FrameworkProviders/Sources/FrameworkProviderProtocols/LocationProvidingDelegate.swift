//
//  LocationProvidingDelegate.swift
//  FrameworkProviders
//
//  Created by Eric Silverberg on 9/15/25.
//

import FrameworkProviderProtocolModels

public protocol LocationProvidingDelegate: AnyObject {
    func didUpdateLocation(locations: [PSSLocation])
    func didFailWithError(error: Error)
    func didChangeAuthorization(status: LocationAuthorizationStatus)
}

