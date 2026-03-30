//
//  Colors.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import Foundation
import SwiftUI

public struct Colors {
    public init(
        background: Color, primary: Color, primaryHigh: Color, primaryLow: Color, primaryPressed: Color, onPrimary: Color, onPrimaryInverse: Color,
        subscription: Color,
        subscriptionHigh: Color, subscriptionPlaceholder: Color, onSubscription: Color, surfaceContainer: Color, surfaceContainerSecondary: Color,
        surfaceContainerInverse: Color, surfaceContainerDisabled: Color, surfaceContainerLowest: Color, surfaceContainerLow: Color, surfaceContainerMid: Color,
        surfaceContainerHigh: Color, surfaceContainerHighest: Color, surfaceContainerOnGradient: Color, onSurfaceVariant: Color, onSurfaceVariantInverse: Color,
        onSurfaceContainerInverse: Color, outline: Color, outlineVariant: Color, scrim: Color, scrimDim: Color, onScrim: Color, onScrimVariant: Color,
        onScrimVariantLow: Color, surface: Color, onSurface: Color, surfaceInverse: Color, onSurfaceInverse: Color, inactive: Color, recent: Color,
        active: Color, verified: Color, onVerified: Color, indicatorsHighlight: Color, error: Color, onError: Color, success: Color, onSuccess: Color,
        promotion: Color, shadow: Color, tertiaryFixed: Color, destructive: Color, placeholder: Color, onPlaceholder: Color, videoRecord: Color,
        incomingMessageBubbleColor: Color, incomingMessageTextColor: Color, outgoingMessageTextColor: Color, solidTabIndicatorColor: Color, badgeInverse: Color
    ) {
        self.background = background
        self.primary = primary
        self.primaryHigh = primaryHigh
        self.primaryLow = primaryLow
        self.primaryPressed = primaryPressed
        self.onPrimary = onPrimary
        self.onPrimaryInverse = onPrimaryInverse
        self.subscription = subscription
        self.subscriptionHigh = subscriptionHigh
        self.subscriptionPlaceholder = subscriptionPlaceholder
        self.onSubscription = onSubscription
        self.surfaceContainer = surfaceContainer
        self.surfaceContainerSecondary = surfaceContainerSecondary
        self.surfaceContainerInverse = surfaceContainerInverse
        self.surfaceContainerDisabled = surfaceContainerDisabled
        self.surfaceContainerLowest = surfaceContainerLowest
        self.surfaceContainerLow = surfaceContainerLow
        self.surfaceContainerMid = surfaceContainerMid
        self.surfaceContainerHigh = surfaceContainerHigh
        self.surfaceContainerHighest = surfaceContainerHighest
        self.surfaceContainerOnGradient = surfaceContainerOnGradient
        self.onSurfaceVariant = onSurfaceVariant
        self.onSurfaceVariantInverse = onSurfaceVariantInverse
        self.onSurfaceContainerInverse = onSurfaceContainerInverse
        self.outline = outline
        self.outlineVariant = outlineVariant
        self.scrim = scrim
        self.scrimDim = scrimDim
        self.onScrim = onScrim
        self.onScrimVariant = onScrimVariant
        self.onScrimVariantLow = onScrimVariantLow
        self.surface = surface
        self.onSurface = onSurface
        self.surfaceInverse = surfaceInverse
        self.onSurfaceInverse = onSurfaceInverse
        self.inactive = inactive
        self.recent = recent
        self.active = active
        self.verified = verified
        self.onVerified = onVerified
        self.indicatorsHighlight = indicatorsHighlight
        self.error = error
        self.onError = onError
        self.success = success
        self.onSuccess = onSuccess
        self.promotion = promotion
        self.shadow = shadow
        self.tertiaryFixed = tertiaryFixed
        self.destructive = destructive
        self.placeholder = placeholder
        self.onPlaceholder = onPlaceholder
        self.videoRecord = videoRecord
        self.incomingMessageBubbleColor = incomingMessageBubbleColor
        self.incomingMessageTextColor = incomingMessageTextColor
        self.outgoingMessageTextColor = outgoingMessageTextColor
        self.solidTabIndicatorColor = solidTabIndicatorColor
        self.badgeInverse = badgeInverse
    }

    public var background: Color

    public var primary: Color
    public var primaryHigh: Color
    public var primaryLow: Color
    public var primaryPressed: Color
    public var onPrimary: Color
    public var onPrimaryInverse: Color

    public var subscription: Color
    public var subscriptionHigh: Color
    public var subscriptionPlaceholder: Color
    public var onSubscription: Color

    public var surfaceContainer: Color
    public var surfaceContainerSecondary: Color
    public var surfaceContainerInverse: Color
    public var surfaceContainerDisabled: Color
    public var surfaceContainerLowest: Color
    public var surfaceContainerLow: Color
    public var surfaceContainerMid: Color
    public var surfaceContainerHigh: Color
    public var surfaceContainerHighest: Color
    public var surfaceContainerOnGradient: Color

    public var onSurfaceVariant: Color
    public var onSurfaceVariantInverse: Color
    public var onSurfaceContainerInverse: Color

    public var outline: Color
    public var outlineVariant: Color

    public var scrim: Color
    public var scrimDim: Color
    public var onScrim: Color
    public var onScrimVariant: Color
    public var onScrimVariantLow: Color

    public var surface: Color
    public var onSurface: Color
    public var surfaceInverse: Color
    public var onSurfaceInverse: Color

    public var inactive: Color
    public var recent: Color
    public var active: Color

    public var verified: Color
    public var onVerified: Color
    public var indicatorsHighlight: Color

    public var error: Color
    public var onError: Color

    public var success: Color
    public var onSuccess: Color

    public var promotion: Color

    public var shadow: Color
    public var tertiaryFixed: Color

    public var destructive: Color

    public var placeholder: Color
    public var onPlaceholder: Color
    public var videoRecord: Color

    public var incomingMessageBubbleColor: Color
    public var incomingMessageTextColor: Color
    public var outgoingMessageTextColor: Color

    public var solidTabIndicatorColor: Color

    public var badgeInverse: Color
}
