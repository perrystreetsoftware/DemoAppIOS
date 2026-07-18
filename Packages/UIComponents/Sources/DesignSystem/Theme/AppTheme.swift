//
//  AppTheme.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import SwiftUI
import Foundation

open class AppTheme: ThemeImplementing {
    open var name = "Default"
    open var colors: Colors = AppTheme.DefaultColors

    public var spacing: SpacingRoles
    public var padding: PaddingRoles = PaddingRoles.Default
    public var sizing: SizingRoles
    private let getGridColumnWidthLogic = GetGridColumnWidthLogic()

    public init() {
        let spacingRoles = SpacingRoles.DefaultPhone
        self.spacing = spacingRoles
        let columnRoles = ColumnRoles(
            gutter: spacingRoles.gridSystemGutter,
            columnWidth: getGridColumnWidthLogic(),
            maxColumns: spacingRoles.gridSystemMaxColumns)
        self.sizing = SizingRoles.DefaultPhone(columnRoles: columnRoles)
    }

    private static let DefaultColors = Colors(
        background: ColorPrimitives.Black._100,
        primary: ColorPrimitives.BlueFree._500,
        primaryHigh: ColorPrimitives.BlueFree._500,
        primaryLow: ColorPrimitives.BlueFree._500,
        primaryPressed: ColorPrimitives.BlueFree._500.opacity(0.15),
        onPrimary: ColorPrimitives.White._100,
        onPrimaryInverse: ColorPrimitives.Black._100,
        subscription: ColorPrimitives.RedPro._500,
        subscriptionHigh: ColorPrimitives.RedPro._500,
        subscriptionPlaceholder: ColorPrimitives.RedPro._500.opacity(0.25),
        onSubscription: ColorPrimitives.White._100,
        surfaceContainer: ColorPrimitives.DarkGray._100,
        surfaceContainerSecondary: ColorPrimitives.DarkGray._100,
        surfaceContainerInverse: ColorPrimitives.BlueFree._500,
        surfaceContainerDisabled: ColorPrimitives.White._25,
        surfaceContainerLowest: ColorPrimitives.Black._25,
        surfaceContainerLow: ColorPrimitives.Black._15,
        surfaceContainerMid: ColorPrimitives.Black._25,
        surfaceContainerHigh: ColorPrimitives.White._15,
        surfaceContainerHighest: ColorPrimitives.Black._15,
        surfaceContainerOnGradient: ColorPrimitives.White._25,
        onSurfaceVariant: ColorPrimitives.White._60,
        onSurfaceVariantInverse: ColorPrimitives.Black._60,
        onSurfaceContainerInverse: ColorPrimitives.White._100,
        outline: ColorPrimitives.White._100,
        outlineVariant: ColorPrimitives.White._15,
        scrim: ColorPrimitives.Black._60,
        scrimDim: ColorPrimitives.Black._85,
        onScrim: ColorPrimitives.White._100,
        onScrimVariant: ColorPrimitives.White._60,
        onScrimVariantLow: ColorPrimitives.White._15,
        surface: ColorPrimitives.Black._100,
        onSurface: ColorPrimitives.White._100,
        surfaceInverse: ColorPrimitives.White._100,
        onSurfaceInverse: ColorPrimitives.Black._100,
        inactive: ColorPrimitives.LightGray._100,
        recent: ColorPrimitives.BearHoney._700,
        active: ColorPrimitives.Malachite._500,
        verified: ColorPrimitives.BlueFree._500,
        onVerified: ColorPrimitives.White._100,
        indicatorsHighlight: ColorPrimitives.LatexPurple._500,
        error: ColorPrimitives.RedPro._700,
        onError: ColorPrimitives.White._100,
        success: ColorPrimitives.Malachite._500,
        onSuccess: ColorPrimitives.White._100,
        promotion: ColorPrimitives.Malachite._700,
        shadow: ColorPrimitives.Black._100,
        tertiaryFixed: ColorPrimitives.White._100,
        destructive: ColorPrimitives.RedPro._700,
        placeholder: ColorPrimitives.MidGray._25,
        onPlaceholder: ColorPrimitives.White._100,
        videoRecord: ColorPrimitives.RedPro._500,
        incomingMessageBubbleColor: ColorPrimitives.LightestGray._100,
        incomingMessageTextColor: ColorPrimitives.Black._100,
        outgoingMessageTextColor: ColorPrimitives.White._100,
        solidTabIndicatorColor: ColorPrimitives.White._100,
        badgeInverse: ColorPrimitives.BlueFree._500
    )
}
