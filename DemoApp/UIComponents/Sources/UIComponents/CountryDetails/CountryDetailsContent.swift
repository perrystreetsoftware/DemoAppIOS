//
//  File.swift
//
//
//  Created by Eric Silverberg on 9/18/22.
//

import Foundation
import SwiftUI
import DomainModels
import Utils

/// Content is a component of a page. Content accepts bindings or simple primitive types.
public struct CountryDetailsContent: View {
    let countryName: String
    let detailsText: String

    public init(countryName: String, detailsText: String) {
        self.countryName = countryName
        self.detailsText = detailsText
    }

    public var body: some View {
        VStack {
            ScrollView {
                Text(detailsText)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }
        }
        .navigationBarTitle(countryName)
    }
}

struct CountryDetailsContent_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailsContent(countryName: "United States", detailsText: "Now is the time for all good men to come to the aid of their country.")
    }
}
