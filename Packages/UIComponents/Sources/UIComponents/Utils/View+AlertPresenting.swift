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
    private let state: DialogUiState
    
    public init(item: Binding<T?>, state: DialogUiState) {
        self._item = item
        self.state = state
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $item.mappedToBool(), content: {
                return DialogAlertFactory.make(state: state)
            })
    }
}

final class DialogAlertFactory {
    static func make(state: DialogUiState) -> Alert {
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
    }
}

private struct PSSToastAlertModifier<T>: ViewModifier where T: Identifiable & Equatable {
    @Binding private var item: T?
    private let state: ToastUiState
    
    public init(item: Binding<T?>, state: ToastUiState) {
        self._item = item
        self.state = state
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(item.publisher, perform: { newValue in
                
                let banner = StatusBarNotificationBanner(
                    title: state.message.stringValue,
                    style: .success
                )
                banner.show()
                
                item = nil
            })
    }
}

extension View {
    @ViewBuilder
    public func pss_notify<T>(_ item: Binding<T?>) -> some View where T: Identifiable & Equatable & FloatingAlertProviding {
        if let alert = item.wrappedValue?.floatingAlert {
            switch alert {
            case .toast(let state):
                self.modifier(PSSToastAlertModifier(item: item, state: state))
                
            case .dialog(let state):
                self.modifier(PSSSwiftNativeDialogAlertModifier(item: item, state: state))
            }
        } else {
            self
        }
    }
    
    @ViewBuilder
    public func pss_notify<T>(item: Binding<T?>, alertBuilder: @escaping (T) -> FloatingAlert) -> some View where T: Identifiable & Equatable {
        if let wrappedValue = item.wrappedValue {
            switch alertBuilder(wrappedValue) {
            case .toast(let state):
                self.modifier(PSSToastAlertModifier(item: item, state: state))

            case .dialog(let state):
                self.modifier(PSSSwiftNativeDialogAlertModifier(item: item, state: state))
            }
        } else {
            self
        }
    }
}
