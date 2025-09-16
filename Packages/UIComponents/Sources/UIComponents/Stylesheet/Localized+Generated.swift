// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

// MARK: - Strings

public enum L10n {
  public enum Errors {
    /// Unable to connect to servers.
    public static let connectionErrorMessage1 = LocalizedString(table: "Errors", lookupKey: "connection_error_message1", localizedStringKeyBase: "connection_error_message1")
    /// Please try again later.
    public static let connectionErrorMessage2 = LocalizedString(table: "Errors", lookupKey: "connection_error_message2", localizedStringKeyBase: "connection_error_message2")
    /// A connection error occurred.
    public static let connectionErrorTitle = LocalizedString(table: "Errors", lookupKey: "connection_error_title", localizedStringKeyBase: "connection_error_title")
    /// Would you like to go to a random country instead?
    public static let countryListBlockedErrorMessage = LocalizedString(table: "Errors", lookupKey: "country_list_blocked_error_message", localizedStringKeyBase: "country_list_blocked_error_message")
    /// Go to random
    public static let countryListBlockedErrorPositiveButton = LocalizedString(table: "Errors", lookupKey: "country_list_blocked_error_positive_button", localizedStringKeyBase: "country_list_blocked_error_positive_button")
    /// This country is blocked
    public static let countryListBlockedErrorTitle = LocalizedString(table: "Errors", lookupKey: "country_list_blocked_error_title", localizedStringKeyBase: "country_list_blocked_error_title")
    /// This country is not available at the moment
    public static let countryNotAvailableErrorMessage = LocalizedString(table: "Errors", lookupKey: "country_not_available_error_message", localizedStringKeyBase: "country_not_available_error_message")
    /// Country not found
    public static let countryNotFoundErrorMessage = LocalizedString(table: "Errors", lookupKey: "country_not_found_error_message", localizedStringKeyBase: "country_not_found_error_message")
    /// Error
    public static let countryNotFoundErrorTitle = LocalizedString(table: "Errors", lookupKey: "country_not_found_error_title", localizedStringKeyBase: "country_not_found_error_title")
    /// This operation is forbidden
    public static let forbiddenErrorMessage = LocalizedString(table: "Errors", lookupKey: "forbidden_error_message", localizedStringKeyBase: "forbidden_error_message")
    /// Error
    public static let forbiddenErrorTitle = LocalizedString(table: "Errors", lookupKey: "forbidden_error_title", localizedStringKeyBase: "forbidden_error_title")
    /// An error occurred.
    public static let genericErrorMessage = LocalizedString(table: "Errors", lookupKey: "generic_error_message", localizedStringKeyBase: "generic_error_message")
    /// Error
    public static let genericErrorTitle = LocalizedString(table: "Errors", lookupKey: "generic_error_title", localizedStringKeyBase: "generic_error_title")
    /// You have just experience an other error.
    public static let otherErrorMessage1 = LocalizedString(table: "Errors", lookupKey: "other_error_message_1", localizedStringKeyBase: "other_error_message_1")
    /// Maybe if you learn about this app it will go away.
    public static let otherErrorMessage2 = LocalizedString(table: "Errors", lookupKey: "other_error_message_2", localizedStringKeyBase: "other_error_message_2")
    /// Some Other Error
    public static let otherErrorTitle = LocalizedString(table: "Errors", lookupKey: "other_error_title", localizedStringKeyBase: "other_error_title")
    /// Please login to continue.
    public static let userNotLoggedInMessage = LocalizedString(table: "Errors", lookupKey: "user_not_logged_in_message", localizedStringKeyBase: "user_not_logged_in_message")
    /// User not logged in
    public static let userNotLoggedInTitle = LocalizedString(table: "Errors", lookupKey: "user_not_logged_in_title", localizedStringKeyBase: "user_not_logged_in_title")
  }
  public enum Localizable {
    /// Placeholder
    public static let placeholder = LocalizedString(table: "Localizable", lookupKey: "placeholder", localizedStringKeyBase: "placeholder")
  }
  public enum Ui {
    /// Cancel
    public static let cancelButtonTitle = LocalizedString(table: "UI", lookupKey: "cancel_button_title", localizedStringKeyBase: "cancel_button_title")
    /// Countries
    public static let countriesTitle = LocalizedString(table: "UI", lookupKey: "countries_title", localizedStringKeyBase: "countries_title")
    /// Unknown
    public static let countryNameUnknownTitle = LocalizedString(table: "UI", lookupKey: "country_name_unknown_title", localizedStringKeyBase: "country_name_unknown_title")
    /// Fail not logged in
    public static let failNotLoggedInTitle = LocalizedString(table: "UI", lookupKey: "fail_not_logged_in_title", localizedStringKeyBase: "fail_not_logged_in_title")
    /// Fail (about page)
    public static let failOtherTitle = LocalizedString(table: "UI", lookupKey: "fail_other_title", localizedStringKeyBase: "fail_other_title")
    /// Invalid
    public static let invalidTitle = LocalizedString(table: "UI", lookupKey: "invalid_title", localizedStringKeyBase: "invalid_title")
    /// Loading...
    public static let loading = LocalizedString(table: "UI", lookupKey: "loading", localizedStringKeyBase: "loading")
    /// Error
    public static let locationStateError = LocalizedString(table: "UI", lookupKey: "location_state_error", localizedStringKeyBase: "location_state_error")
    /// Unknown
    public static let locationStateUnknown = LocalizedString(table: "UI", lookupKey: "location_state_unknown", localizedStringKeyBase: "location_state_unknown")
    /// Updating location
    public static let locationStateUpdating = LocalizedString(table: "UI", lookupKey: "location_state_updating", localizedStringKeyBase: "location_state_updating")
    /// Your location: %@
    public static func locationStateYourLocation(_ p1: Any) -> LocalizedString {
      let lookupKeyArg1 = String(describing: p1)
      return LocalizedString(table: "UI",
                             lookupKey: "location_state_your_location %@",
                             localizedStringKeyBase: "location_state_your_location \(lookupKeyArg1)",
                             args: String(describing: p1))
    }
    /// OK
    public static let ok = LocalizedString(table: "UI", lookupKey: "ok", localizedStringKeyBase: "ok")
    /// Refresh (always will fail)
    public static let refreshButtonTitle = LocalizedString(table: "UI", lookupKey: "refresh_button_title", localizedStringKeyBase: "refresh_button_title")
    /// Server status is not OK
    public static let serverStatusNotOk = LocalizedString(table: "UI", lookupKey: "server_status_not_ok", localizedStringKeyBase: "server_status_not_ok")
    /// Server status is OK
    public static let serverStatusOk = LocalizedString(table: "UI", lookupKey: "server_status_ok", localizedStringKeyBase: "server_status_ok")
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

public struct LocalizedString {
  let table: String
  fileprivate let lookupKey: String
  fileprivate let localizedStringKeyBase: LocalizedStringKey
  fileprivate let args: [CVarArg]

  init(table: String, lookupKey: String, localizedStringKeyBase: LocalizedStringKey, args: CVarArg...) {
    self.table = table
    self.lookupKey = lookupKey
    self.localizedStringKeyBase = localizedStringKeyBase
    self.args = args
  }

  private var key: LocalizedStringKey {
    LocalizedStringKey(lookupKey)
  }

  public var text: Text {
    Text(localizedStringKeyBase, tableName: table, bundle: BundleToken.bundle)
  }

  public var stringValue: String {
    tr(table, lookupKey, Locale.current, args)
  }

  func stringValue(withLocale locale: Locale) -> String {
    tr(table, lookupKey, locale, args)
  }
}

extension LocalizedString: Hashable {
  public static func == (lhs: LocalizedString, rhs: LocalizedString) -> Bool {
    return lhs.table == rhs.table &&
    lhs.lookupKey == rhs.lookupKey
  }

  public func hash(into hasher: inout Hasher) {
      hasher.combine(table)
      hasher.combine(lookupKey)
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
