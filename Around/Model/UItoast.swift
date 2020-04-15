//
//  UItoast.swift
//  Around
//
//  Created by מאור ידין on 05/04/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import SwiftEntryKit

class UItoast {
    
    static func toastTOP(text:String) {
                // Generate top floating entry and set some properties
                var attributes = EKAttributes.topFloat
        
        attributes.entryBackground = .color(color: EKColor(UIColor(red: 191, green: 237, blue: 245)))

                attributes.border = .value(color: .black, width: 0.5)
                attributes.displayDuration = 2
                attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributes.statusBar = .dark
                attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)

        let title = EKProperty.LabelContent(text: text, style: .init(font: UIFont(name: "Times New Roman", size: 19.0)!, color: .black))
                
                let description = EKProperty.LabelContent(text: text, style: .init(font: UIFont(name: "Times New Roman", size: 19.0)!, color: .white))
                
        //        let image = EKProperty.ImageContent(image: UIImage(named: "profileImage")!, size: CGSize(width: 35, height: 35))
                let simpleMessage = EKSimpleMessage( title: title, description: description)
                let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

                let contentView = EKNotificationMessageView(with: notificationMessage)
                SwiftEntryKit.display(entry: contentView, using: attributes)

                
    }
}
