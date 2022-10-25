// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

// MARK: - Strings

public enum L10n {
  public enum Errors {
    /// Country not found
    public static let countryNotFoundErrorMessage = LocalizedString(table: "Errors", lookupKey: "country_not_found_error_message")
    /// Error
    public static let countryNotFoundErrorTitle = LocalizedString(table: "Errors", lookupKey: "country_not_found_error_title")
    /// This operation is forbidden
    public static let forbiddenErrorMessage = LocalizedString(table: "Errors", lookupKey: "forbidden_error_message")
    /// Error
    public static let forbiddenErrorTitle = LocalizedString(table: "Errors", lookupKey: "forbidden_error_title")
    /// An error occurred.
    public static let genericErrorMessage = LocalizedString(table: "Errors", lookupKey: "generic_error_message")
    /// Error
    public static let genericErrorTitle = LocalizedString(table: "Errors", lookupKey: "generic_error_title")
  }
  public enum Localizable {
    /// Placeholder
    public static let placeholder = LocalizedString(table: "Localizable", lookupKey: "placeholder")
  }
  public enum Ui {
    /// Cancel
    public static let cancelButtonTitle = LocalizedString(table: "UI", lookupKey: "cancel_button_title")
    /// Countries
    public static let countriesTitle = LocalizedString(table: "UI", lookupKey: "countries_title")
    /// Unknown
    public static let countryNameUnknownTitle = LocalizedString(table: "UI", lookupKey: "country_name_unknown_title")
    /// Invalid
    public static let invalidTitle = LocalizedString(table: "UI", lookupKey: "invalid_title")
    /// Loading...
    public static let loading = LocalizedString(table: "UI", lookupKey: "loading")
    /// Refresh (always will fail)
    public static let refreshButtonTitle = LocalizedString(table: "UI", lookupKey: "refresh_button_title")
    /// Server status is not OK
    public static let serverStatusNotOk = LocalizedString(table: "UI", lookupKey: "server_status_not_ok")
    /// Server status is OK
    public static let serverStatusOk = LocalizedString(table: "UI", lookupKey: "server_status_ok")
  }
}

// MARK: - Implementation Details
fileprivate func tr(_ table: String, _ key: String, _ locale: Locale = Locale.current, _ args: CVarArg...) -> String {
  let path = Bundle.main.path(forResource: locale.identifier, ofType: "lproj") ?? ""
  let format: String
  if let bundle = Bundle(path: path) {
    format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
  } else {
    format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
  }
  return String(format: format, locale: locale, arguments: args)
}

public struct LocalizedString: Hashable {
  let table: String
  fileprivate let lookupKey: String

  init(table: String, lookupKey: String) {
    self.table = table
    self.lookupKey = lookupKey
  }

  private var key: LocalizedStringKey {
    LocalizedStringKey(lookupKey)
  }

  public var text: Text {
    Text(key, tableName: table, bundle: BundleToken.bundle)
  }

  public var stringValue: String {
    tr(table, lookupKey)
  }

  func stringValue(withLocale locale: Locale) -> String {
    tr(table, lookupKey, locale)
  }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
      return Bundle.module
    #else
      return Bundle(for: BundleToken.self)
    #endif
  }()
}
