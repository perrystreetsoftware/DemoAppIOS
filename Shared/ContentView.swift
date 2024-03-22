//
//  ContentView.swift
//  Shared
//
//  Created by Eric Silverberg on 9/10/22.
//

import SwiftUI
import UIComponents
import Utils
import SDWebImageSVGCoder

public struct PSSSVG: UIViewRepresentable {
    public func updateUIView(_ uiView: UIImageView, context: Context) {
    }

    public init() {
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIImageView {
        let view = UIImageView()

        view.sd_setImage(
            with: Bundle.main.url(forResource: "inkscape", withExtension: "svg")!, placeholderImage: nil, context: [.imagePreserveAspectRatio: true, .imageThumbnailPixelSize: CGSize(width: 500, height: 500)])
        return view
    }
}


struct ContentView: View {
    var body: some View {
        PSSSVG()
            .background(.red)
            .frame(width: 500, height: 500)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PSSSVG()
    }
}
