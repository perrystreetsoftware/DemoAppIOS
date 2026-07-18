//
//  ColumnRoles.swift
//  DesignSystem
//
//  Created by Eric Silverberg on 11/26/25.
//

import Foundation
import SwiftUI

internal struct ColumnRoles {
    init(
        gutter: CGFloat,
        columnWidth: CGFloat,
        maxColumns: Int
    ) {
        self.gutter = gutter
        self.columnWidth = columnWidth
        self.maxColumns = maxColumns
    }

    private let columnWidth: CGFloat
    private let gutter: CGFloat
    private let maxColumns: Int

    /// Returns the width of a single column according to our Grid System. On an iPhone, we will only
    /// have 6 columns, but their exact width can fluctuate based on the phone size, appx 52.0 wide
    /// On an iPad, we will have 12 columns, and again their width will fluctuate based on portrait
    /// or landscape
    ///
    /// Note: columns must be >= 1; anything less than that will be rounded up to 1
    internal func widthOf(columns: Int) -> CGFloat {
        let clampedColumns = max(columns, 1)

        return (CGFloat(clampedColumns - 1) * gutter) + CGFloat(clampedColumns) * columnWidth
    }
}
