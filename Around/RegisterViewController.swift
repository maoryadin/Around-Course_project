//
//  RegisterViewController.swift
//  Around
//
//  Created by מאור ידין on 18/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    var db:Firestore!
    var myUser:UserData!
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    var imageView = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
           let settings = FirestoreSettings()

          Firestore.firestore().settings = settings
            // [END setup]
          db = Firestore.firestore()
    }
    
    
    @IBAction func registerOnClick(_ sender: Any) {
        
        if(usernameField.text != nil && emailField.text != nil && passwordField.text != nil && ageField.text != nil && firstNameField.text != nil && lastNameField.text != nil){
            
            
            FireBaseManager.CreateAccount(email: emailField.text!, password: passwordField.text!) {
                        (result:String) in
                DispatchQueue.main.async{
                    FireBaseManager.Login(email: self.emailField.text!, password: self.passwordField.text!) { (success:Bool) in
                        
                        if(success){
                            print("success login from register")
                            self.addUserDetails()

                        }
                    }
            }
            }
        }

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        
    }
    
    @IBAction func backBarItem(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    func addUserDetails() {

        let uid = Auth.auth().currentUser?.uid
        print(uid!)


        imageView.image = UIImage(named:"profileImage")
    
        print("compressing image..")
        if let data = self.imageView.image?.jpegData(compressionQuality: 0.75) {
    
            print("profile image is compressed")
              let ref = FireBaseManager.getRef(path: "account/\(uid!)/profileImage.jpeg")
            FireBaseManager.uploadFile(data: data, ref: ref,completion: {})
            
            myUser = UserData(first: firstNameField.text!, last: lastNameField.text!, profilePic: ref.fullPath, email: emailField.text!, uid: uid!, age: ageField.text!,username: usernameField.text!)

                      //   print("enter to add doc func")

            db.collection("Users").document(uid!).setData(myUser.toJson(), merge: true) { (Error) in
                self.performSegue(withIdentifier: "profileSegue", sender: self)

            }
//            db.collection("Users").document(uid!).setData(myUser.toJson(),merge: true,completion: {
//                self.performSegue(withIdentifier: "profileSegue", sender: self)
//            })
            
            print("collection is created")
        }

            
        
    
        
    }
    
}
