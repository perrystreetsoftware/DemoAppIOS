import Interfaces
import Combine
import Foundation
import FrameworkProviderProtocols

public final class TravelAdvisoryApi: TravelAdvisoryApiImplementing {
    private let appScheduler: AppSchedulerProviding

    public init(appScheduler: AppSchedulerProviding) {
        self.appScheduler = appScheduler
    }

    public func getForbiddenApi() -> AnyPublisher<Void, TravelAdvisoryApiError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "httpstat.us"
        components.path = "/403"

        guard let url = components.url else {
            preconditionFailure("Failed to construct URL")
        }

        var task: URLSessionDataTask!

        return Deferred {
            Future<Void, TravelAdvisoryApiError> { promise in
                task = URLSession.shared.dataTask(with: url) {
                    data, response, error in

                    guard let httpResponse = response as? HTTPURLResponse else {
                        promise(.failure(TravelAdvisoryApiError(statusCode: 0, responseData: nil)))
                        return
                    }
                    let apiResponseCode = ApiResponseCode(rawValue: httpResponse.statusCode)

                    if apiResponseCode == .success {
                        promise(.success(()))
                    } else {
                        promise(.failure(TravelAdvisoryApiError(statusCode: httpResponse.statusCode,
                                                                responseData: data)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: appScheduler.mainScheduler)
        .delay(for: .seconds(1),
               scheduler: appScheduler.mainScheduler)
        .eraseToAnyPublisher()
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

                    guard let httpResponse = response as? HTTPURLResponse else {
                        if let error: Error = error {
                            promise(.failure(TravelAdvisoryApiError.otherError(error)))
                        } else {
                            promise(.failure(TravelAdvisoryApiError.invalidResponseCode(.unknown)))
                        }

                        return
                    }
                    let apiResponseCode = ApiResponseCode(rawValue: httpResponse.statusCode)

                    if apiResponseCode == .success {

                        do {
                            let decoded = try JSONDecoder().decode(CountryListDTO.self, from: data!)
                            promise(.success(decoded))
                        } catch {
                            promise(.failure(TravelAdvisoryApiError.otherError(error)))
                        }
                    } else {
                        promise(.failure(TravelAdvisoryApiError(statusCode: httpResponse.statusCode,
                                                                responseData: data)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: appScheduler.mainScheduler)
        .delay(for: .seconds(1), scheduler: appScheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

    public func getCountryDetails(regionCode: String) -> AnyPublisher<CountryDetailsDTO, TravelAdvisoryApiError> {
        var components = URLComponents()

        if regionCode == "xx" {
            components.scheme = "https"
            components.host = "httpstat.us"
            components.path = "/404"
        } else {
            components.scheme = "https"
            components.host = "www.scruff.com"
            components.path = "/advisories/\(regionCode)/index.json"
        }
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

                    let httpResponse = response as? HTTPURLResponse
                    let apiResponseCode = ApiResponseCode(rawValue: httpResponse?.statusCode ?? 0)

                    if apiResponseCode == .success {
                        do {
                            let decoded = try decoder.decode(CountryDetailsDTO.self, from: data!)
                            promise(.success(decoded))
                        } catch {
                            // We are mocking this behavior here - production API does not unfortunately return 404 and instead returns a 200 to the home page
                            promise(.failure(TravelAdvisoryApiError.domainError(.countryNotFound, responseCode: .notFound)))
                        }
                    } else {
                        promise(.failure(TravelAdvisoryApiError(statusCode: httpResponse?.statusCode ?? 0,
                                                                responseData: data)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: appScheduler.mainScheduler)
        .delay(for: .seconds(1), scheduler: appScheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

    public func getServerStatus() -> AnyPublisher<ServerStatusDTO, TravelAdvisoryApiError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "status.scruff.com"
        components.path = "/index.json"

        guard let url = components.url else {
            preconditionFailure("Failed to construct URL")
        }

        var task: URLSessionDataTask!

        return Deferred {
            Future<ServerStatusDTO, TravelAdvisoryApiError> { promise in
                task = URLSession.shared.dataTask(with: url) {
                    data, response, error in

                    guard let httpResponse = response as? HTTPURLResponse else {
                        if let error: Error = error {
                            promise(.failure(TravelAdvisoryApiError.otherError(error)))
                        } else {
                            promise(.failure(TravelAdvisoryApiError.invalidResponseCode(.unknown)))
                        }

                        return
                    }
                    let apiResponseCode = ApiResponseCode(rawValue: httpResponse.statusCode)

                    if apiResponseCode == .success {

                        do {
                            let decoded = try JSONDecoder().decode(ServerStatusDTO.self, from: data!)
                            promise(.success(decoded))
                        } catch {
                            promise(.failure(TravelAdvisoryApiError.otherError(error)))
                        }
                    } else {
                        promise(.failure(TravelAdvisoryApiError(statusCode: httpResponse.statusCode,
                                                                responseData: data)))
                    }
                }

                task.resume()
            }
        }
        .receive(on: appScheduler.mainScheduler)
        .delay(for: .seconds(1), scheduler: appScheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

}
