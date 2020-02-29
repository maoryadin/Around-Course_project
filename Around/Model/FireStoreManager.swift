//
//  FireStoreManager.swift
//  Around
//
//  Created by מאור ידין on 23/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class FireStoreManager : NSObject {
    
    
    static func getImage(ref:StorageReference) -> UIImage? {
    
        var image:UIImage?
                    ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if error != nil {
                            print("error")
                        image = nil
                            return
                      } else {
                            print("success")
                           image = UIImage(data: data!)
                            return
                      }
                    }
    
        
        
//        while(image == nil){
//            print("cpu burn")
//        }
        
            return image

    }
}
