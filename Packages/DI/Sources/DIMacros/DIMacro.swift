import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension MemberBlockItemListSyntax {
    var hasConstructorAlready: Bool {
        self.contains(where: { item in
            item.decl.is(InitializerDeclSyntax.self)
        })
    }
}
extension VariableDeclSyntax {
    /// Check if this variable has the syntax of a stored property.
    var isStoredProperty: Bool {
        guard let binding = bindings.first,
              bindings.count == 1,
              !isLazyProperty,
              !isConstant else {
            return false
        }

        // this ignores computed properties like `var x: Int { 5 }`
        if binding.accessorBlock != nil {
            return false
        }

        return true
    }

    var isLazyProperty: Bool {
        modifiers.contains { $0.name.tokenKind == .keyword(Keyword.lazy) }
    }

    var isConstant: Bool {
        bindingSpecifier.tokenKind == .keyword(Keyword.let) && bindings.first?.initializer != nil
    }
}

extension DeclGroupSyntax {
    /// Get the stored properties from the declaration based on syntax.
    func storedProperties() -> [VariableDeclSyntax] {
        return memberBlock.members.compactMap { member in
            guard let variable = member.decl.as(VariableDeclSyntax.self),
                  variable.isStoredProperty else {
                return nil
            }

            return variable
        }
    }
}

public struct SingleMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        return []
    }
}

public struct DIMacro: MemberMacro {

    enum Errors: Swift.Error, CustomStringConvertible {
        case invalidInputType

        var description: String {
            "@DI macro is only applicable to structs or classes"
        }
    }

    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {

        let storedProperties: [VariableDeclSyntax] = try {
            if let classDeclaration = declaration.as(ClassDeclSyntax.self) {
                return classDeclaration.storedProperties()
            } else if let structDeclaration = declaration.as(StructDeclSyntax.self) {
                return structDeclaration.storedProperties()
            } else {
                throw Errors.invalidInputType
            }
        }()

        guard declaration.memberBlock.members.hasConstructorAlready == false else {
            return []
        }

        let initArguments = storedProperties.compactMap { property -> (name: String, type: String)? in
            guard let patternBinding = property.bindings.first?.as(PatternBindingSyntax.self) else {
                return nil
            }

            if property.attributes.count > 0,
                let attSyntax = property.attributes.first?.as(AttributeSyntax.self),
                let ident = attSyntax.attributeName.as(IdentifierTypeSyntax.self),
                ident.name.text == "Published" {
                return nil
            }

            guard let name = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                  let type = patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.as(SimpleTypeIdentifierSyntax.self)?.name else {
                return nil
            }

            return (name: name.text, type: type.text)
        }

        let initBody: ExprSyntax = "\(raw: initArguments.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n"))"

        let initDeclSyntax = try InitializerDeclSyntax(
            PartialSyntaxNodeString(stringLiteral: "init(\(initArguments.map { "\($0.name): \($0.type)" }.joined(separator: ", ")))"),
            bodyBuilder: {
                initBody
            }
        )

        let finalDeclaration = DeclSyntax(initDeclSyntax)

        return [finalDeclaration]
    }
}

@main
struct DIPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DIMacro.self,
        SingleMacro.self
    ]
}
