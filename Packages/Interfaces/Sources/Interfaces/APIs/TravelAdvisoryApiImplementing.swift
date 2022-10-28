import DomainModels
import Combine
import Foundation

public protocol TravelAdvisoryApiImplementing {
    func getForbiddenApi() -> AnyPublisher<Void, TravelAdvisoryApiError>
    func getCountryList() -> AnyPublisher<CountryListDTO, TravelAdvisoryApiError>
    func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError>
    func getServerStatus() -> AnyPublisher<ServerStatusDTO, TravelAdvisoryApiError>
}

public enum TravelAdvisoryApiDomainApiError: DomainApiError {
    case countryNotFound
    case forbidden

    public init?(responseCode: ApiResponseCode, responseData: Data?) {
        switch responseCode {
        case .notFound:
            self = .countryNotFound
        case .forbidden:
            self = .forbidden
        default:
            return nil
        }
    }
}

public typealias TravelAdvisoryApiError = ApiError<TravelAdvisoryApiDomainApiError>
