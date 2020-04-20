//
//  UiView.swift
//  Around
//
//  Created by Ron on 19/04/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // gradient
    func setGradientLayer(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

class TextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 24, left: 15, bottom: 0, right: 15))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 24, left: 15, bottom: 0, right: 15))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets.init(top: 24, left: 15, bottom: 0, right: 15))
    }
}
