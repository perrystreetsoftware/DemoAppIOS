import Foundation
import DomainModels
import Swinject
import Logic

public final class CountryDetailsViewModelFactory {
    private var resolver: Swinject.Resolver

    init(resolver: Swinject.Resolver) {
        self.resolver = resolver
    }

    public func make(country: Country) -> CountryDetailsViewModel {
        return CountryDetailsViewModel(country: country,
                                       logic: resolver.resolve(CountryDetailsLogic.self)!)
    }
}
