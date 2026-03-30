//
//  SizingRoles.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import CoreFoundation
import Foundation

public struct SizingRoles {
    public let iconXXS: CGFloat
    public let iconXS: CGFloat
    public let iconS: CGFloat
    public let iconM: CGFloat
    public let iconL: CGFloat
    public let iconXL: CGFloat
    public let iconXXL: CGFloat
    public let avatarXS: CGFloat
    public let avatarS: CGFloat
    public let avatarM: CGFloat
    public let avatarL: CGFloat
    public let avatarXL: CGFloat
    public let radiusXS: CGFloat
    public let radiusS: CGFloat
    public let radiusM: CGFloat
    public let radiusL: CGFloat
    public let radiusXL: CGFloat
    public let horizontalRuleXS: CGFloat
    public let horizontalRuleS: CGFloat
    public let horizontalRuleM: CGFloat

    public let dynamicColumnS: CGFloat
    public let dynamicColumnM: CGFloat
    public let dynamicColumnL: CGFloat
    public let fixedColumnXS: CGFloat
    public let fixedColumnS: CGFloat
    public let fixedColumnM: CGFloat
    public let fixedColumnL: CGFloat
    public let fixedColumnXL: CGFloat

    public let interactionHeightCompact: CGFloat
    public let interactionHeightDefault: CGFloat
    public let interactionHeightComfort: CGFloat

    internal init(
        iconXXS: CGFloat,
        iconXS: CGFloat,
        iconS: CGFloat,
        iconM: CGFloat,
        iconL: CGFloat,
        iconXL: CGFloat,
        iconXXL: CGFloat,
        avatarXS: CGFloat,
        avatarS: CGFloat,
        avatarM: CGFloat,
        avatarL: CGFloat,
        avatarXL: CGFloat,
        radiusXS: CGFloat,
        radiusS: CGFloat,
        radiusM: CGFloat,
        radiusL: CGFloat,
        radiusXL: CGFloat,
        horizontalRuleXS: CGFloat,
        horizontalRuleS: CGFloat,
        horizontalRuleM: CGFloat,
        dynamicColumnS: Int,
        dynamicColumnM: Int,
        dynamicColumnL: Int,
        fixedColumnXS: Int,
        fixedColumnS: Int,
        fixedColumnM: Int,
        fixedColumnL: Int,
        fixedColumnXL: Int,
        columnRoles: ColumnRoles,
        interactionHeightCompact: CGFloat,
        interactionHeightDefault: CGFloat,
        interactionHeightComfort: CGFloat
    ) {
        self.iconXXS = iconXXS
        self.iconXS = iconXS
        self.iconS = iconS
        self.iconM = iconM
        self.iconL = iconL
        self.iconXL = iconXL
        self.iconXXL = iconXXL
        self.avatarXS = avatarXS
        self.avatarS = avatarS
        self.avatarM = avatarM
        self.avatarL = avatarL
        self.avatarXL = avatarXL
        self.radiusXS = radiusXS
        self.radiusS = radiusS
        self.radiusM = radiusM
        self.radiusL = radiusL
        self.radiusXL = radiusXL
        self.horizontalRuleXS = horizontalRuleXS
        self.horizontalRuleS = horizontalRuleS
        self.horizontalRuleM = horizontalRuleM

        self.dynamicColumnS = columnRoles.widthOf(columns: dynamicColumnS)
        self.dynamicColumnM = columnRoles.widthOf(columns: dynamicColumnM)
        self.dynamicColumnL = columnRoles.widthOf(columns: dynamicColumnL)
        self.fixedColumnXS = columnRoles.widthOf(columns: fixedColumnXS)
        self.fixedColumnS = columnRoles.widthOf(columns: fixedColumnS)
        self.fixedColumnM = columnRoles.widthOf(columns: fixedColumnM)
        self.fixedColumnL = columnRoles.widthOf(columns: fixedColumnL)
        self.fixedColumnXL = columnRoles.widthOf(columns: fixedColumnXL)

        self.interactionHeightCompact = interactionHeightCompact
        self.interactionHeightDefault = interactionHeightDefault
        self.interactionHeightComfort = interactionHeightComfort
    }

    private static func createSizingRoles(
        dynamicColumnS: Int,
        dynamicColumnM: Int,
        dynamicColumnL: Int,
        fixedColumnXS: Int,
        fixedColumnS: Int,
        fixedColumnM: Int,
        fixedColumnL: Int,
        fixedColumnXL: Int,
        columnRoles: ColumnRoles,
        radiusXS: CGFloat,
        radiusS: CGFloat,
        radiusM: CGFloat,
        radiusL: CGFloat,
        radiusXL: CGFloat
    ) -> SizingRoles {
        SizingRoles(
            iconXXS: SizingPrimitives.size8.rawValue,
            iconXS: SizingPrimitives.size12.rawValue,
            iconS: SizingPrimitives.size16.rawValue,
            iconM: SizingPrimitives.size24.rawValue,
            iconL: SizingPrimitives.size32.rawValue,
            iconXL: SizingPrimitives.size44.rawValue,
            iconXXL: SizingPrimitives.size108.rawValue,
            avatarXS: SizingPrimitives.size24.rawValue,
            avatarS: SizingPrimitives.size40.rawValue,
            avatarM: SizingPrimitives.size60.rawValue,
            avatarL: SizingPrimitives.size88.rawValue,
            avatarXL: SizingPrimitives.size188.rawValue,
            radiusXS: radiusXS,
            radiusS: radiusS,
            radiusM: radiusM,
            radiusL: radiusL,
            radiusXL: radiusXL,
            horizontalRuleXS: 1,
            horizontalRuleS: SizingPrimitives.size2.rawValue,
            horizontalRuleM: SizingPrimitives.size4.rawValue,
            dynamicColumnS: dynamicColumnS,
            dynamicColumnM: dynamicColumnM,
            dynamicColumnL: dynamicColumnL,
            fixedColumnXS: fixedColumnXS,
            fixedColumnS: fixedColumnS,
            fixedColumnM: fixedColumnM,
            fixedColumnL: fixedColumnL,
            fixedColumnXL: fixedColumnXL,
            columnRoles: columnRoles,
            interactionHeightCompact: SizingPrimitives.size32.rawValue,
            interactionHeightDefault: SizingPrimitives.size48.rawValue,
            interactionHeightComfort: SizingPrimitives.size56.rawValue
        )
    }

    internal static func DefaultPhone(columnRoles: ColumnRoles) -> Self {
        return Self.createSizingRoles(
            dynamicColumnS: 2,
            dynamicColumnM: 4,
            dynamicColumnL: 5,
            fixedColumnXS: 1,
            fixedColumnS: 2,
            fixedColumnM: 4,
            fixedColumnL: 5,
            fixedColumnXL: 6,
            columnRoles: columnRoles,
            radiusXS: SizingPrimitives.size2.rawValue,
            radiusS: SizingPrimitives.size4.rawValue,
            radiusM: SizingPrimitives.size8.rawValue,
            radiusL: SizingPrimitives.size12.rawValue,
            radiusXL: SizingPrimitives.size20.rawValue
        )
    }

    internal static func DefaultPad(columnRoles: ColumnRoles) -> Self {
        return Self.createSizingRoles(
            dynamicColumnS: 4,
            dynamicColumnM: 8,
            dynamicColumnL: 10,
            fixedColumnXS: 1,
            fixedColumnS: 2,
            fixedColumnM: 4,
            fixedColumnL: 5,
            fixedColumnXL: 6,
            columnRoles: columnRoles,
            radiusXS: SizingPrimitives.size2.rawValue,
            radiusS: SizingPrimitives.size8.rawValue,
            radiusM: SizingPrimitives.size12.rawValue,
            radiusL: SizingPrimitives.size16.rawValue,
            radiusXL: SizingPrimitives.size24.rawValue
        )
    }
}
