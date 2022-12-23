//
//  File.swift
//  
//
//  Created by Eric Silverberg on 12/21/22.
//

import Foundation

public struct DialogAction {
    public let title: LocalizedString
    public let action: (() -> Void)?

    public init(title: LocalizedString,
                action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    public func copy(title: LocalizedString? = nil,
                     action: (() -> Void)? = nil) -> DialogAction {
        return DialogAction(title: title ?? self.title,
                            action: action ?? self.action)
    }
}

public struct DialogUiState {
    public let title: LocalizedString
    public let messages: [LocalizedString]
    public let positiveAction: DialogAction?
    public let negativeAction: DialogAction?

    public init(title: LocalizedString,
                messages: [LocalizedString],
                positiveAction: DialogAction? = nil,
                negativeAction: DialogAction? = nil) {
        self.title = title
        self.messages = messages
        self.positiveAction = positiveAction
        self.negativeAction = negativeAction
    }
}

