//
//  PaddingRoles.swift
//  DesignSystem
//
//  Created by Eric Silverberg on 12/2/25.
//

import CoreFoundation
import Foundation

public struct PaddingRoles {
    /// Standard top safe-area spacing applied between the system UI (status bar, notch, navigation header) and the first page content.
    public let screenTopRegular: CGFloat

    /// Compact bottom safe-area spacing for screens with minimal air at the bottom.
    public let screenBottomCompact: CGFloat

    /// Standard bottom safe-area spacing applied between the last page content and the system UI (tab bar, home indicator, bottom navigation).
    public let screenBottomRegular: CGFloat

    /// Expanded bottom safe-area spacing for screens that require extra air at the bottom.
    public let screenBottomExpanded: CGFloat

    /// Fixed horizontal page gutter applied between screen edges (safe area) and page content.
    public let screenHorizontal: CGFloat

    /// Extra Compact spacing from a element to the content it labels.
    public let elementExtraCompact: CGFloat

    /// Compact spacing from a element to the content it labels.
    public let elementCompact: CGFloat

    /// Regular spacing from a element to the content it labels.
    public let elementRegular: CGFloat

    /// Relaxed spacing from a element to the content it labels.
    public let elementRelaxed: CGFloat

    /// Expanded spacing from a element to the content it labels.
    public let elementExpanded: CGFloat

    /// Extra Expanded spacing from an element to the content it labels.
    public let elementExtraExpanded: CGFloat

    private init(
        screenTopRegular: CGFloat,
        screenBottomCompact: CGFloat,
        screenBottomRegular: CGFloat,
        screenBottomExpanded: CGFloat,
        screenHorizontal: CGFloat,
        elementExtraCompact: CGFloat,
        elementCompact: CGFloat,
        elementRegular: CGFloat,
        elementRelaxed: CGFloat,
        elementExpanded: CGFloat,
        elementExtraExpanded: CGFloat
    ) {
        self.screenTopRegular = screenTopRegular
        self.screenBottomCompact = screenBottomCompact
        self.screenBottomRegular = screenBottomRegular
        self.screenBottomExpanded = screenBottomExpanded
        self.screenHorizontal = screenHorizontal
        self.elementExtraCompact = elementExtraCompact
        self.elementCompact = elementCompact
        self.elementRegular = elementRegular
        self.elementRelaxed = elementRelaxed
        self.elementExpanded = elementExpanded
        self.elementExtraExpanded = elementExtraExpanded
    }

    public static let Default = PaddingRoles(
        screenTopRegular: SpacingPrimitives.space60.rawValue,
        screenBottomCompact: SpacingPrimitives.space20.rawValue,
        screenBottomRegular: SpacingPrimitives.space40.rawValue,
        screenBottomExpanded: SpacingPrimitives.space60.rawValue,
        screenHorizontal: SpacingPrimitives.space20.rawValue,
        elementExtraCompact: SpacingPrimitives.space2.rawValue,
        elementCompact: SpacingPrimitives.space4.rawValue,
        elementRegular: SpacingPrimitives.space8.rawValue,
        elementRelaxed: SpacingPrimitives.space12.rawValue,
        elementExpanded: SpacingPrimitives.space20.rawValue,
        elementExtraExpanded: SpacingPrimitives.space24.rawValue
    )
}
