import Combine
import DomainModels
import Foundation

public final class GetLatinAmericaCountriesLogic {
    private let countryListLogic: CountryListLogic

    public init(countryListLogic: CountryListLogic) {
        self.countryListLogic = countryListLogic
    }

    public func callAsFunction() -> AnyPublisher<[Country], Error> {
        return countryListLogic.$continents
            .map { $0.filter { $0.name.lowercased() == "latin america" }.flatMap { $0.countries } }
            .filter { $0.isEmpty == false }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
