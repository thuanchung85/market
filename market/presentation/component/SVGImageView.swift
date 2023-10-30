//
//  SVGImageView.swift
//  market
//
//  Created by Admin on 27/10/2023.
//

import Foundation
import SwiftUI
import SVGKit
import LightweightCharts
import UIKit

struct SVGImageView: UIViewRepresentable {
    var url:URL
    var size:CGSize
    
    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        uiView.contentMode = .scaleAspectFit
        uiView.image.size = size
        
    }
    
    func makeUIView(context: Context) -> SVGKFastImageView {
        let svgImage = SVGKImage(contentsOf: url)
        svgImage?.uiImage.withTintColor(.red, renderingMode: .alwaysTemplate)
        return SVGKFastImageView(svgkImage: svgImage ?? SVGKImage())
    }
}

