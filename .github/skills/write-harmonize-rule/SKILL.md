---
name: write-harmonize-rule
description: Guide for creating new Harmonize lint rules that enforce architectural patterns and best practices. Use this when asked to write a lint rule or enforce an architectural pattern.
---

# Writing Harmonize Rules

Harmonize is a Swift static-analysis library that lets us write architectural and structural lint rules as unit tests. Rules are `QuickSpec` BDD tests (Given/When/Then) in `Packages/LintRules/Tests/LintRulesTests/`. Subfolders group rules by category. Each file contains a **single lint rule** as a QuickSpec test class that fails when the rule is violated.

## Rule Template

```swift
import Foundation
import Quick
import UtilsTestExtensions
import Harmonize
import HarmonizeSemantics

final class MyRuleName: QuickSpec {
    override class func spec() {
        Given("A descriptive context for the rule") {
            let items = HarmonizeTravelAdvisories.someScope

            When("A condition is checked") {   // When is optional
                Then("The expected property holds") {
                    items.assertTrue(message: Self.message, baseline: Self.baseline) {
                        // predicate
                    }
                }
            }
        }
    }

    private static let message = LintRuleMessage(
        rule: "Short description of what the rule checks.",
        why: """
            Architectural reasoning — why does this rule exist?
            What problem does it prevent?
            """,
        howToFix: "Concrete steps to fix a violation.",
        badExample: """
            class BadExample {
                // code that violates the rule
            }
            """,
        goodExample: """
            class GoodExample {
                // code that follows the rule
            }
            """
    )

    // Only include if there are actual violations. Use filenames with `.swift`:
    private static let baseline = [
        "KnownViolation1.swift",
        "KnownViolation2.swift",
    ]
}
```

### Baseline

A baseline is a list of files (filenames with `.swift`) that currently violate the rule and are grandfathered until they can be fixed. **Pass the baseline as a parameter to the assertion** — never use `.withoutName(baseline)` to filter the items list, because:

- The assertion's `baseline:` parameter performs a stale-baseline check: if a baselined element starts passing, it reports an error so the entry can be removed.
- `.withoutName(baseline)` silently drops elements from the input, so stale entries are never noticed.

When the assertion runs against children of a container (e.g. `viewModels.functions()`), prefer asserting on the container with `allSatisfy` inside the predicate so the baseline matches at the file/container level cleanly:

```swift
viewModels.assertTrue(message: message, baseline: baseline) { viewModel in
    viewModel.functions.allSatisfy { ... }
}
```

This avoids stale-baseline noise when a file contains a mix of passing and failing children.

This pattern is enforced by the `DoNotUseWithoutNameForBaseline` meta-lint rule.

**When a rule has multiple assertions**, keep a separate baseline per assertion containing only the elements that violate that specific assertion.

### LintRuleMessage

All new rules **must** use `LintRuleMessage` for assertion messages. This is enforced by the `AllRulesMustUseLintRuleMessage` meta-lint rule.

`LintRuleMessage` is a struct at `Packages/LintRules/Tests/LintRulesTests/LintRuleMessage.swift` with the following required fields:

| Field         | Purpose                                                                           |
| ------------- | --------------------------------------------------------------------------------- |
| `rule`        | Short description of what the rule checks                                         |
| `why`         | Architectural reasoning — why does this rule exist? What problem does it prevent? |
| `howToFix`    | Concrete steps to fix a violation                                                 |
| `badExample`  | Code example that violates the rule                                               |
| `goodExample` | Code example that follows the rule                                                |

Wrapper extension functions for `assertTrue`, `assertFalse`, and `assertEmpty` are defined in the same file (for both declaration arrays and `SwiftSourceCode` arrays). These accept `message: LintRuleMessage` instead of `message: String?` and are called identically.

Use `"""` multiline strings for any field value that spans multiple lines. Never use `+` to concatenate strings across lines.

When a rule has **multiple Then blocks with different assertions**, create a separate `LintRuleMessage` for each assertion. The `why` field can be the same across messages if they share the same architectural reasoning.

## Key Conventions

- Always extend `QuickSpec` with `Given`/`When`/`Then` blocks.
- Always use `LintRuleMessage` for assertion messages — never use raw strings.
- Never call `Harmonize.productionCode()` or `Harmonize.testCode()` directly — use `HarmonizeTravelAdvisories` scopes.
- Baselines and allowed lists use `[String]` arrays as `private static let` properties.
- Define `LintRuleMessage` instances as `private static let message`.

## Harmonize API Reference

All Harmonize APIs are accessed through `HarmonizeTravelAdvisories` and the `Harmonize`/`HarmonizeSemantics` imports.

### Scopes

Scopes define which source files a rule applies to. Defined in `HarmonizeTravelAdvisories` (`Packages/LintRules/Tests/LintRulesTests/HarmonizeTravelAdvisories.swift`).

**Always use pre-defined scopes from `HarmonizeTravelAdvisories`:**

| Scope                        | What it covers                              |
| ---------------------------- | ------------------------------------------- |
| `productionCode`             | All production source files                 |
| `testCode`                   | All test source files                       |
| `viewModelsPackage`          | ViewModels package (source files)           |
| `logicPackage`               | Logic package (source files)                |
| `repositoriesPackage`        | Repositories package (source files)         |
| `domainModelsPackage`        | DomainModels package (source files)         |
| `interfacesPackage`          | Interfaces package (source files)           |
| `frameworkProvidersPackage`  | FrameworkProviders package (source files)   |
| `uiComponentsPackage`        | UIComponents package (source files)         |
| `presentationFeaturePackage` | Feature package (screens, adapters, pages)  |

### Pre-filtered Entity Lists

| Property                 | Returns                          |
| ------------------------ | -------------------------------- |
| `viewModelsProduction`   | Classes ending with `ViewModel`  |
| `logicProduction`        | Classes ending with `Logic`      |
| `repositoriesProduction` | Classes ending with `Repository` |
| `classesProduction`      | All production classes           |
| `protocolsProduction`    | All production protocols         |
| `classesTest`            | All test classes                 |

The `presentationFeaturePackage.views` helper returns SwiftUI views (structs conforming to `View`) in the Feature package.

### AST Navigation

From a scope:

- `scope.sources()` — all source files
- `scope.classes()` — all classes
- `scope.structs()` — all structs
- `scope.enums()` — all enums
- `scope.protocols()` — all protocols
- `scope.extensions()` — all extensions
- `scope.functions()` — all top-level functions

From entities:

- `class.variables()` / `class.functions()` / `class.initializers()`
- `class.enums()` — nested enums
- `class.closures()` — closures within the class
- `class.inherits(from: "ClassName")` — checks inheritance
- `class.conforms(to: "ProtocolName")` — checks conformance
- `class.inheritanceTypesNames` — parent type names
- `class.parent` — parent declaration (for nested types)
- `source.imports()` — import declarations

### Filtering

Use Harmonize's built-in filtering methods instead of `.filter { }`. **Avoid regular expressions** unless there is no Harmonize API that covers the check — the built-in methods are more readable and maintainable:

**Name-based:**

```swift
.withName("ExactName")
.withoutName("LegacyClass")
.withNameEndingWith("ViewModel")
.withoutNameEndingWith("JsonMapper")
.withNameStartingWith("Get")
.withNameContaining("Tap")
.withNameMatching(regex)
.withoutNameContaining("Legacy")
.withoutNameStartingWith("PSS")
```

**Modifier-based:**

```swift
.withModifier(.public)
.withoutModifier(.private)
```

**Relationship-based:**

```swift
.inheriting(from: "BaseViewModel")
.conforming(to: Error.self)
.withImport("Repositories")
.withAttribute(annotatedWith: .published)
.withType { $0.name == "SomeType" }
.withBodyContent(containing: "someString")
```

**Path-based:**

```swift
.withSuffix("ViewModel")
.withoutSuffix("Tests")
.withPrefix("PSS")
.withoutPrefix("Legacy")
```

### Assertions

Use the `LintRuleMessage` overloads from `LintRuleMessage.swift`:

| Assertion                                  | Purpose                                                |
| ------------------------------------------ | ------------------------------------------------------ |
| `list.assertTrue(message:) { predicate }`  | Every item must satisfy the predicate                  |
| `list.assertFalse(message:) { predicate }` | No item may satisfy the predicate                      |
| `list.assertEmpty(message:)`               | List must be empty (use after filtering to violations) |
| `list.assertNotEmpty()`                    | List must not be empty (no message parameter)          |

## Steps

1. **Create the rule** following the template. One rule per file. Place it in the most logical category folder (`ui/`, `viewmodels/`, `logic/`, `repositories/`, `protocols/`, `styling/`, `combine/`, `tests/`).
    - **Note:** This skill covers the most commonly used patterns. If you need an API not listed here, first study existing rules in `Packages/LintRules/Tests/LintRulesTests/` — they are the ground truth for what the project uses.
2. **Run the rule** using the `run-harmonize` skill.
3. **Handle violations:** `baseline` = violations to fix later. `allowed` = intentionally permitted exceptions. Never create empty baseline or allowed arrays — omit them if there are none.
4. **Re-run** to confirm it passes.
