//
//  Service.swift
//  Around
//
//  Created by מאור ידין on 11/04/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import UIKit
class Service {
    
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            for action in actions {
                alert.addAction(action)
            }
            on.present(alert, animated: true, completion: completion)
    }
}
