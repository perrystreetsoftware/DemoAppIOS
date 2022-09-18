import DomainModels
import Combine

public enum TravelAdvisoryApiError: Error {
    case networkError
    case decodingError
    case other
}

public protocol TravelAdvisoryApiImplementing {
    func getCountryList() -> AnyPublisher<CountryListDTO, TravelAdvisoryApiError>
    func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError>
}
