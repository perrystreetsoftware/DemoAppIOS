import Interfaces
import Combine
import Foundation
import DomainModels

public final class CountryListProvider: CountryListProviding {
    public func getCountryList() -> AnyPublisher<CountryListDTO, CountryListProvidingError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.scruff.com"
        components.path = "/advisories/index.json"

        guard let url = components.url else {
            preconditionFailure("Failed to construct URL")
        }

        var task: URLSessionDataTask!

        return Deferred {
            Future<CountryListDTO, CountryListProvidingError> { promise in
                task = URLSession.shared.dataTask(with: url) {
                    data, response, error in

                    do {
                        if let data = data {
                            let decoded = try JSONDecoder().decode(CountryListDTO.self, from: data)
                            promise(.success(decoded))
                        } else {
                            promise(.failure(CountryListProvidingError.other))
                        }
                    } catch {
                        promise(.failure((.decodingError)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: DispatchQueue.main)
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    public func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, CountryListProvidingError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.scruff.com"
        components.path = "/advisories/\(regionCode)/index.json"

        guard let url = components.url else {
            preconditionFailure("Failed to construct URL")
        }

        var task: URLSessionDataTask!

        return Deferred {
            Future<CountryDetailsDTO, CountryListProvidingError> { promise in
                task = URLSession.shared.dataTask(with: url) {
                    data, response, error in

                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    do {
                        if let data = data {
                            let decoded = try decoder.decode(CountryDetailsDTO.self, from: data)
                            promise(.success(decoded))
                        } else {
                            promise(.failure(CountryListProvidingError.other))
                        }
                    } catch {
                        promise(.failure((.decodingError)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: DispatchQueue.main)
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
