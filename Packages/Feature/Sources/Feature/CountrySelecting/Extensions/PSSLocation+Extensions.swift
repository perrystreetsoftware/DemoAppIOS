//
//  PSSLocation+Extensions.swift
//  Feature
//
//  Created by Eric Silverberg on 9/15/25.
//

import ViewModels
import FrameworkProviderProtocolModels
import UIComponents

extension PSSLocation {
    var uiString: String {
        let roundedLatitude = String(format: "%.2f", latitude)
        let roundedLongitude = String(format: "%.2f", longitude)

        return "\(roundedLatitude), \(roundedLongitude)"
    }
}
