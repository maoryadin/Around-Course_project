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
    static var user:UserData?
    static var db:Firestore! = Firestore.firestore()
    let settings = FirestoreSettings()

    static func Login(email: String, password: String ,completion:
        @escaping (_ success: Bool, _ error: String) -> Void) {

        Auth.auth().signIn(withEmail: email, password: password,
                           completion: { (user, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                completion(false, error.localizedDescription)
                            } else {
                                currentUser = user?.user
                                currentUserId = (((user?.user.uid)!))
                                //Get specific document from current user
                                 let userDB = UserData.getUserFromDb()

                                if(userDB != nil) {
                                   self.user = userDB
                                    db = Firestore.firestore()
                                    completion(true, "")
                                    return
                                }
                                let docRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "")

                                // Get data
                                docRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let dataDescription = document.data()
                                        self.user = UserData(json: dataDescription!)
                                        UserData.addToDb(user: self.user!)
                                        db = Firestore.firestore()
                                        completion(true, "")
                                    }
                                }
                               // completion(true)
                            }

        })
    }

    static func CreateAccount(email:String, password:String,_user:UserData, completion:
        @escaping (_ result: String, _ error: String) -> Void) {
        
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                        print(error.localizedDescription)
                    completion("fail", error.localizedDescription)
                            return
                        }
                _user.uid = Auth.auth().currentUser!.uid
                db.collection("Users").document(_user.uid).setData(_user.toJson()) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        completion("success","")
                    }
                }
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
        //print("path:\(pathRef.fullPath)")
        return pathRef
        
        
    }
    
    static func uploadFile(data:Data,ref:StorageReference,completion: (()->(Void))?) {
        
        //print(ref.fullPath)
        _ = ref.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
          // Uh-oh, an error occurred!
                print("error upload file")
          return
        }
           
            guard completion != nil  else {
                print("upload complete with nil")
                return
            }
            
            completion!()
    }
}
    
    static func getImageFromStorage(ref:StorageReference) -> UIImage? {

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

            return image

    }
    static func deleteFrom(collection:String,document:String){
        db.collection(collection).document(document).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }

}

