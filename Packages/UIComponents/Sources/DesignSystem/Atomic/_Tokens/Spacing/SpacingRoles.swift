//
//  SpacingRoles.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//


import SwiftUI

public struct SpacingRoles {
    /// Max columns in our grid system
    public let gridSystemMaxColumns: Int

    /// The gutter size in our grid system
    public let gridSystemGutter: CGFloat

    /// Compact vertical spacing used between modules within a page.
    public let moduleCompact: CGFloat

    /// Regular vertical spacing used between modules within a page.
    public let moduleRegular: CGFloat

    /// Expanded vertical spacing used between modules within a page.
    public let moduleExpanded: CGFloat

    /// Expanded extra vertical spacing used between modules within a page.
    public let moduleExtraExpanded: CGFloat

    /// Compact spacing from a header element to the content it labels.
    public let headerContentCompact: CGFloat

    /// Regular spacing from a header element to the content it labels.
    public let headerContentRegular: CGFloat

    /// Expanded spacing from a header element to the content it labels.
    public let headerContentExpanded: CGFloat

    /// Extra-compact spacing from a component element to the content it labels.
    public let componentExtraCompact: CGFloat

    /// Compact spacing from a component element to the content it labels.
    public let componentCompact: CGFloat

    /// Cozy spacing from a component element to the content it labels.
    public let componentCozy: CGFloat

    /// Regular spacing from a component element to the content it labels.
    public let componentRegular: CGFloat

    /// Relaxed spacing from a component element to the content it labels.
    public let componentRelaxed: CGFloat

    /// Expanded spacing from a component to the content it labels.
    public let componentExpanded: CGFloat

    private init(
        gridSystemMaxColumns: Int,
        gridSystemGutter: CGFloat,
        moduleCompact: CGFloat,
        moduleRegular: CGFloat,
        moduleExpanded: CGFloat,
        moduleExtraExpanded: CGFloat,
        headerContentCompact: CGFloat,
        headerContentRegular: CGFloat,
        headerContentExpanded: CGFloat,
        componentExtraCompact: CGFloat,
        componentCompact: CGFloat,
        componentCozy: CGFloat,
        componentRegular: CGFloat,
        componentRelaxed: CGFloat,
        componentExpanded: CGFloat
    ) {
        self.gridSystemMaxColumns = gridSystemMaxColumns
        self.gridSystemGutter = gridSystemGutter
        self.moduleCompact = moduleCompact
        self.moduleRegular = moduleRegular
        self.moduleExpanded = moduleExpanded
        self.moduleExtraExpanded = moduleExtraExpanded
        self.headerContentCompact = headerContentCompact
        self.headerContentRegular = headerContentRegular
        self.headerContentExpanded = headerContentExpanded
        self.componentExtraCompact = componentExtraCompact
        self.componentCompact = componentCompact
        self.componentCozy = componentCozy
        self.componentRegular = componentRegular
        self.componentRelaxed = componentRelaxed
        self.componentExpanded = componentExpanded
    }

    private static func createSpacingRoles(
        gridSystemMaxColumns: Int,
        gridSystemGutter: CGFloat,
        componentCompact: CGFloat
    ) -> SpacingRoles {
        SpacingRoles(
            gridSystemMaxColumns: gridSystemMaxColumns,
            gridSystemGutter: gridSystemGutter,
            moduleCompact: SpacingPrimitives.space20.rawValue,
            moduleRegular: SpacingPrimitives.space40.rawValue,
            moduleExpanded: SpacingPrimitives.space60.rawValue,
            moduleExtraExpanded: SpacingPrimitives.space88.rawValue,
            headerContentCompact: SpacingPrimitives.space0.rawValue,
            headerContentRegular: SpacingPrimitives.space20.rawValue,
            headerContentExpanded: SpacingPrimitives.space40.rawValue,
            componentExtraCompact: SpacingPrimitives.space4.rawValue,
            componentCompact: componentCompact,
            componentCozy: SpacingPrimitives.space12.rawValue,
            componentRegular: SpacingPrimitives.space16.rawValue,
            componentRelaxed: SpacingPrimitives.space20.rawValue,
            componentExpanded: SpacingPrimitives.space24.rawValue
        )
    }

    public static let DefaultPhone: SpacingRoles = Self.createSpacingRoles(
        gridSystemMaxColumns: 6,
        gridSystemGutter: SpacingPrimitives.space8.rawValue,
        componentCompact: SpacingPrimitives.space8.rawValue
    )

    public static let DefaultPad: SpacingRoles = Self.createSpacingRoles(
        gridSystemMaxColumns: 12,
        gridSystemGutter: SpacingPrimitives.space16.rawValue,
        componentCompact: SpacingPrimitives.space20.rawValue
    )
}
