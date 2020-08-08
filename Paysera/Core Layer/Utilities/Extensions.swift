//
//  Extensions.swift
//  Paysera
//
//  Created by Jeric Miana on 8/8/20.
//  Copyright © 2020 Jeric Miana. All rights reserved.
//

import UIKit


// MARK: - UIView

extension UIView {
    func setGradientBackground() {
        
        let leftColor = UIColor(red: 1/255, green: 156/255, blue: 222/255, alpha: 1.0)
        let rightColor = UIColor(red: 6/255, green: 133/255, blue: 198/255, alpha: 1.0)
        
        let gradient = CAGradientLayer()
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        gradient.frame = bounds
        gradient.cornerRadius = self.layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.height / 2
    }
}

// MARK: - String

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}
