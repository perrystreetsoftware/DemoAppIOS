//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/21/22.
//

import Foundation
import SwiftUI
// This should be done via interfaces
import NotificationBannerSwift

private struct PSSSwiftNativeDialogAlertModifier<T>: ViewModifier where T: Identifiable & Equatable {
    @Binding private var item: T?
    private let alertBuilder: (T) -> FloatingAlert

    public init(item: Binding<T?>, alertBuilder: @escaping (T) -> FloatingAlert) {
        self._item = item
        self.alertBuilder = alertBuilder
    }

    func body(content: Content) -> some View {
        content
            .alert(isPresented: Binding(get: {
                guard let item = _item.wrappedValue else { return false }

                if case .dialog = alertBuilder(item) {
                    return true
                } else {
                    return false
                }
            }, set: { newValue, _ in
                guard newValue == false else { return }
                /// We only handle `false` booleans to set our optional to `nil`
                /// as we can't handle `true` for restoring the previous value.
                item = nil
            })) {
                guard let item = _item.wrappedValue else {
                    return Alert(title: Text(""))
                }

                let alertPresentationType = alertBuilder(item)

                if case .dialog(let state) = alertPresentationType {
                    if let action = state.action {
                        return Alert(title: Text(state.title.stringValue),
                                     message: Text(state.messages.joinedByDefaultSeparator),
                                     primaryButton: .default(Text(L10n.Ui.ok.stringValue),
                                                             action: { action() }),
                                     secondaryButton: .cancel())
                    } else {
                        return Alert(title: Text(state.title.stringValue),
                                     message: Text(state.messages.joinedByDefaultSeparator))

                    }
                } else {
                    return Alert(title: Text(""))
                }
            }
    }
}

private struct PSSToastAlertModifier<T>: ViewModifier where T: Identifiable & Equatable {
    @Binding private var item: T?
    private let alertBuilder: (T) -> FloatingAlert

    public init(item: Binding<T?>, alertBuilder: @escaping (T) -> FloatingAlert) {
        self._item = item
        self.alertBuilder = alertBuilder
    }

    func body(content: Content) -> some View {
        content
            .onReceive(item.publisher.filter({ newValue in
                let alertPresentationType = alertBuilder(newValue)

                if case .toast = alertPresentationType {
                    return true
                } else {
                    return false
                }
            }), perform: { newValue in
                let alertPresentationType = alertBuilder(newValue)

                if case .toast(let toastState) = alertPresentationType {
                    // This should have been done via injected interfaces
                    let banner = StatusBarNotificationBanner(title: toastState.message.stringValue,
                                                             style: .success)
                    banner.show()
                }

                item = nil
            })
    }
}

extension View {
    public func pss_notify<T>(_ item: Binding<T?>) -> some View where T: Identifiable & Equatable & FloatingAlertProviding {
        modifier(PSSSwiftNativeDialogAlertModifier(item: item, alertBuilder: { alert in
            return alert.floatingAlert
        }))
        .modifier(PSSToastAlertModifier(item: item, alertBuilder: { alert in
            return alert.floatingAlert
        }))
    }

    public func pss_notify<T>(item: Binding<T?>, alertBuilder: @escaping (T) -> FloatingAlert) -> some View where T: Identifiable & Equatable {
        modifier(PSSSwiftNativeDialogAlertModifier(item: item, alertBuilder: alertBuilder))
        .modifier(PSSToastAlertModifier(item: item, alertBuilder: alertBuilder))
    }
}
