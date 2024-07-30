//
//  UIView+Extension.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/30/24.
//

import Foundation
import UIKit

extension UIView {
    
    func startShimmer() {
        let light = UIColor(white: 0.9, alpha: 0.8).cgColor
        let dark = UIColor(white: 0.6, alpha: 0.8).cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.name = "shimmerLayer"
        self.layer.addSublayer(gradient)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.0, 0.25]
        animation.toValue = [0.75, 1.0, 1.0]
        animation.duration = 1.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmer() {
        layer.sublayers?.removeAll { $0.name == "shimmerLayer" }
    }
    
    func updateShimmerLayer() {
        if let firstLayer = layer.sublayers?.first(where: { layer in layer.name == "shimmerLayer"}), firstLayer.frame != bounds {
            firstLayer.frame = bounds
        }
    }
}
