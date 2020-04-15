//
//  UIColor+Hex.swift
//  LocationStarterKit
//
//  Created by Takamitsu Mizutori on 2016/08/30.
//  Copyright © 2016年 Goldrush Computing Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
        convenience init(red: Int, green: Int, blue: Int) {
            let newRed = CGFloat(red)/255
            let newGreen = CGFloat(green)/255
            let newBlue = CGFloat(blue)/255
            
            self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
