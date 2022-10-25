// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// Cancel
  public static let cancelButtonTitle = L10n.tr("Localizable", "cancel_button_title")
  /// Countries
  public static let countriesTitle = L10n.tr("Localizable", "countries_title")
  /// This operation is forbidden
  public static let forbiddenErrorMessage = L10n.tr("Localizable", "forbidden_error_message")
  /// Error
  public static let forbiddenErrorTitle = L10n.tr("Localizable", "forbidden_error_title")
  /// An error occurred.
  public static let genericErrorMessage = L10n.tr("Localizable", "generic_error_message")
  /// Error
  public static let genericErrorTitle = L10n.tr("Localizable", "generic_error_title")
  /// Server status is not OK
  public static let serverStatusNotOk = L10n.tr("Localizable", "server_status_not_ok")
  /// Server status is OK
  public static let serverStatusOk = L10n.tr("Localizable", "server_status_ok")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
