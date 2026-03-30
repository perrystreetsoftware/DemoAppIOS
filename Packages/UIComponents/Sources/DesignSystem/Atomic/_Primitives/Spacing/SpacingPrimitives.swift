//
//  SpacingPrimitives.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import CoreGraphics
import Foundation

public enum SpacingPrimitives: CGFloat, CaseIterable {
    case space0 = 0
    case space2 = 2
    case space4 = 4
    case space8 = 8
    case space12 = 12
    case space16 = 16
    case space20 = 20
    case space24 = 24
    case space32 = 32
    case space40 = 40
    case space44 = 44
    case space48 = 48
    case space56 = 56
    case space60 = 60
    case space72 = 72

    // These should not be used -- use ColumnRoles
    case space88 = 88
    case space108 = 108

    case space28 = 28 // This is not part of the design system.
    case space36 = 36 // This is not part of the design system.
    case space52 = 52 // This is not part of the design system.
    case space64 = 64 // This is not part of the design system.
    case space68 = 68 // This is not part of the design system.
    case space76 = 76 // This is not part of the design system.
    case space80 = 80 // This is not part of the design system.
    case space92 = 92 // This is not part of the design system.
    case space96 = 96 // This is not part of the design system.
    case space100 = 100 // This is not part of the design system.
    case space104 = 104 // This is not part of the design system.
    case space112 = 112 // This is not part of the design system.
    case space116 = 116 // This is not part of the design system.
    case space120 = 120 // This is not part of the design system.
    case space124 = 124 // This is not part of the design system.
    case space132 = 132 // This is not part of the design system.
    case space144 = 144 // This is not part of the design system.
    case space168 = 168 // This is not part of the design system.
    case space208 = 208 // This is not part of the design system.
    case space220 = 220 // This is not part of the design system.
    case space232 = 232 // This is not part of the design system.
    case space240 = 240 // This is not part of the design system.
    case space272 = 272 // This is not part of the design system.
    case space600 = 600 // This is not part of the design system.
}

prefix func - (_ value: SpacingPrimitives) -> CGFloat {
    return -value.rawValue
}
