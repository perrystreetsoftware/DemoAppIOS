//
//  ApiError.swift
//
//
//  Created by Eric Silverberg on 1/31/22.
//

import Foundation

/// Base protocol to implement custom meaning to a subset of response codes.
///
/// See ApiErrorTests.swift for an example
public protocol DomainApiError: Equatable, Error {

    /// Return nil if you're not interested in custom interpretation of provided status code
    init?(responseCode: ApiResponseCode, responseData: Data?)
}

/// An empty custom domain error you can use if you're not interested in any overrides of status code meaning.
public enum EmptyDomainApiError: DomainApiError {
    public init?(responseCode: ApiResponseCode, responseData: Data?) {
        nil
    }
}

/// Convenience typealis for `ApiError<EmptyDomainApiError>`
public typealias GenericApiError = ApiError<EmptyDomainApiError>

/// API error that all API calls should be returning
public enum ApiError<T: DomainApiError>: Error, Equatable {

    /// Custom handling of received status code. See ApiErrorTests.swift for an example.
    case domainError(_ error: T, responseCode: ApiResponseCode)

    /// Represents a status code returned by the backend (notFound, ...)
    case invalidResponseCode(_ responseCode: ApiResponseCode)

    /// Almost always represents a network-level error (no Internet, cerfitiface rejected, ...)
    case otherError(_ error: Error)

    /// Generates .cusom case if the provided `DomainApiError` implementation handles it.
    /// - Parameter statusCode: response status code
    public init(statusCode: Int, responseData: Data? = nil) {
        let responseCode: ApiResponseCode = ApiResponseCode(rawValue: statusCode) ?? ApiResponseCode.unknown

        if let custom = T(responseCode: responseCode, responseData: responseData) {
            self = .domainError(custom, responseCode: responseCode)
        } else {
            self = .invalidResponseCode(responseCode)
        }
    }

    public static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        switch lhs {
        case .domainError(let lcustom, _):
            switch rhs {
            case .domainError(let rcustom, _):
                return lcustom == rcustom
            case .invalidResponseCode, otherError:
                return false
            }
        case .invalidResponseCode(let lStatusCode):
            switch rhs {
            case .invalidResponseCode(let rStatusCode):
                return lStatusCode == rStatusCode
            case .domainError, .otherError:
                return false
            }
        case .otherError(let lError):
            switch rhs {
            case .domainError, .invalidResponseCode:
                return false
            case .otherError(let rError):
                return lError.localizedDescription == rError.localizedDescription
            }
        }
    }
}
