//
//  GetGridColumnWidthLogic.swift
//  UIComponents
//
//  Created by Eric Silverberg on 3/29/26.
//

import Combine
import CoreFoundation
import Foundation
import UIKit

internal final class GetGridColumnWidthLogic {
    private func getScreenWidthLogic() -> CGFloat {
        UIScreen.main.bounds.width
    }

    func callAsFunction() -> CGFloat {
        let spacingRoles = SpacingRoles.DefaultPhone
        let maxColumns = spacingRoles.gridSystemMaxColumns

        let screenWidth = getScreenWidthLogic()
        let screenHorizontal = PaddingRoles.Default.screenHorizontal
        let gutter = spacingRoles.gridSystemGutter

        let gutterSpaceConsumed: CGFloat = CGFloat(maxColumns - 1) * gutter

        let columnWidth: CGFloat =
            (screenWidth - (2 * screenHorizontal) - gutterSpaceConsumed) / CGFloat(maxColumns)

        return columnWidth
    }
}
