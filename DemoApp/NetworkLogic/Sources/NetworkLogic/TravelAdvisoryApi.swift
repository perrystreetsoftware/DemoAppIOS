import Interfaces
import Combine
import Foundation
import DomainModels

public final class TravelAdvisoryApi: TravelAdvisoryApiImplementing {
    private let appScheduler: AppSchedulerProviding

    public init(appScheduler: AppSchedulerProviding) {
        self.appScheduler = appScheduler
    }

    public func getCountryList() -> AnyPublisher<CountryListDTO, TravelAdvisoryApiError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.scruff.com"
        components.path = "/advisories/index.json"

        guard let url = components.url else {
            preconditionFailure("Failed to construct URL")
        }

        var task: URLSessionDataTask!

        return Deferred {
            Future<CountryListDTO, TravelAdvisoryApiError> { promise in
                task = URLSession.shared.dataTask(with: url) {
                    data, response, error in

                    do {
                        if let data = data {
                            let decoded = try JSONDecoder().decode(CountryListDTO.self, from: data)
                            promise(.success(decoded))
                        } else {
                            promise(.failure(TravelAdvisoryApiError.other))
                        }
                    } catch {
                        promise(.failure((.decodingError)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: appScheduler.mainScheduler)
        .delay(for: .seconds(2), scheduler: appScheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

    public func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.scruff.com"
        components.path = "/advisories/\(regionCode)/index.json"

        guard let url = components.url else {
            preconditionFailure("Failed to construct URL")
        }

        var task: URLSessionDataTask!

        return Deferred {
            Future<CountryDetailsDTO, TravelAdvisoryApiError> { promise in
                task = URLSession.shared.dataTask(with: url) {
                    data, response, error in

                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    do {
                        if let data = data {
                            let decoded = try decoder.decode(CountryDetailsDTO.self, from: data)
                            promise(.success(decoded))
                        } else {
                            promise(.failure(TravelAdvisoryApiError.other))
                        }
                    } catch {
                        promise(.failure((.decodingError)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: appScheduler.mainScheduler)
        .delay(for: .seconds(2), scheduler: appScheduler.mainScheduler)
        .eraseToAnyPublisher()
    }
}
