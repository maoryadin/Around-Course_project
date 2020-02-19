//
//  FireBaseManager.swift
//  Around
//
//  Created by מאור ידין on 17/01/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FireBaseManager: NSObject {

    static let databaseRef = Database.database().reference()
    static var currentUserId:String = ""
    static var currentUser:User? = nil

    static func Login(email:String,password:String, completion:
        @escaping (_ success:Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password,
                           completion: { (user, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                completion(false)
                            } else {
                                currentUser = user?.user
                                currentUserId = (((user?.user.uid)!))
                                completion(true)
                            }
                            
        })
    }
    

    static func CreateAccount(email:String, password:String, completion:
        @escaping (_ result:String) -> Void) {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                    print(error.localizedDescription)
                        return
                    }
            
            Login(email: email, password: password) {
                (success:Bool) in
                if(success) {
                    print("login successfull")
                } else {
                    print("login unsuccessfull")
                }
            }
            completion("")
    }
    
    
}
    
    static func AddUser(username:String,password:String) {
        _ = Auth.auth().currentUser?.uid // uid of the user
        
    }
    
    static func getRef(path:String?) -> StorageReference {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        if path == nil {
            return storageRef
        }
        let pathRef = storageRef.child(path!)
        return pathRef
        
        
    }
    
    static func uploadFile(data:Data,ref:StorageReference) {
        
        _ = ref.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
          // Uh-oh, an error occurred!
          return
        }
    }
    
        }
    

}

