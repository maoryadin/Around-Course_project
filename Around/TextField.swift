//
//  TextField.swift
//  Around
//
//  Created by Ron on 17/04/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit

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
