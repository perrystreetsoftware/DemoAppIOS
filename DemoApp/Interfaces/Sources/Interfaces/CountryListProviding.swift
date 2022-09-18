import DomainModels
import Combine

public enum CountryListProvidingError: Error {
    case networkError
    case other
    case decodingError
}

public protocol CountryListProviding {
    func getCountryList() -> AnyPublisher<CountryListDTO, CountryListProvidingError>
    func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, CountryListProvidingError>
}
