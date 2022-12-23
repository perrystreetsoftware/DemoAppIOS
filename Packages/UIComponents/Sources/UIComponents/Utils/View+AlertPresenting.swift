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
            .alert(isPresented: $item.mappedToBool(), content: {
                guard let item = _item.wrappedValue else {
                    return Alert(title: Text(""))
                }

                let alertPresentationType = alertBuilder(item)

                if case .dialog(let state) = alertPresentationType {
                    if let negativeAction: DialogAction = state.negativeAction,
                        let positiveAction = state.positiveAction {
                        return Alert(title: Text(state.title.stringValue),
                                     message: Text(state.messages.joinedByDefaultSeparator),
                                     primaryButton: .default(Text(positiveAction.title.stringValue),
                                                             action: { positiveAction.action?() }),
                                     secondaryButton: .cancel(Text(negativeAction.title.stringValue),
                                                                   action: { negativeAction.action?() })
                        )
                    } else if let positiveAction = state.positiveAction {
                        return Alert(title: Text(state.title.stringValue),
                                     message: Text(state.messages.joinedByDefaultSeparator),
                                     primaryButton: .default(Text(positiveAction.title.stringValue),
                                                             action: { positiveAction.action?() }),
                                     secondaryButton: .cancel())
                    } else {
                        return Alert(title: Text(state.title.stringValue),
                                     message: Text(state.messages.joinedByDefaultSeparator))
                    }
                } else {
                    return Alert(title: Text(""))
                }
            })
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
            .onReceive(item.publisher, perform: { newValue in
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
    @ViewBuilder
    public func pss_notify<T>(_ item: Binding<T?>) -> some View where T: Identifiable & Equatable & FloatingAlertProviding {
        if let alert = item.wrappedValue?.floatingAlert {
            switch alert {
            case .toast:
                self.modifier(PSSToastAlertModifier(item: item, alertBuilder: { alert in
                    return alert.floatingAlert
                }))
                
            case .dialog:
                self.modifier(PSSSwiftNativeDialogAlertModifier(item: item, alertBuilder: { alert in
                    return alert.floatingAlert
                }))
            }
        } else {
            self
        }
    }

    @ViewBuilder
    public func pss_notify<T>(item: Binding<T?>, alertBuilder: @escaping (T) -> FloatingAlert) -> some View where T: Identifiable & Equatable {
        if let wrappedValue = item.wrappedValue {
            switch alertBuilder(wrappedValue) {
            case .toast:
                   self.modifier(PSSToastAlertModifier(item: item, alertBuilder: alertBuilder))

            case .dialog:
                self.modifier(PSSSwiftNativeDialogAlertModifier(item: item, alertBuilder: alertBuilder))
            }
        } else {
            self
        }
    }
}
