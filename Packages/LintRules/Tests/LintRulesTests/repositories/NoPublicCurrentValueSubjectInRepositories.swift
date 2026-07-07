//
//  NoPublicCurrentValueSubjectInRepositories.swift
//  LintRules
//

import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class NoPublicCurrentValueSubjectInRepositories: QuickSpec {
    override class func spec() {
        Given("A repository class in production code") {
            let repositoryClasses = HarmonizeTravelAdvisories.repositoriesProduction

            Then("It does not expose a CurrentValueSubject as a public var") {
                repositoryClasses
                    .variables()
                    .withType {
                        $0.name.contains("CurrentValueSubject")
                    }
                    .assertFalse(message: message) { variable in
                        variable.modifiers.contains(.public)
                    }
            }

            Then("It does not expose a CurrentValueSubject as a public var with an inferred type") {
                repositoryClasses
                    .variables()
                    .assertFalse(message: message) { variable in
                        let isCurrentValueSubject = variable.initializerClause?.value.contains("CurrentValueSubject")
                        let isPublic = variable.modifiers.contains(.public)
                        return isCurrentValueSubject == true && isPublic == true
                    }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Repositories must not expose public CurrentValueSubjects.",
        why: """
            A public CurrentValueSubject lets any consumer push values into the \
            repository's stream, breaking the repository's ownership of its data. \
            @Published with private(set) exposes the same reactive stream read-only.
            """,
        howToFix: """
            Replace the public CurrentValueSubject with `@Published public private(set) var` \
            and update writers to assign to the variable.
            """,
        badExample: """
            @Single
            public final class CountryListRepository {
                public let continents = CurrentValueSubject<[Continent], Never>([])
            }
            """,
        goodExample: """
            @Single
            public final class CountryListRepository {
                @Published public private(set) var continents: [Continent] = []
            }
            """
    )
}
