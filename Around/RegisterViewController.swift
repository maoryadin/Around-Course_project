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
                        DispatchQueue.main.async {


                            self.addUserDetails()
                            self.performSegue(withIdentifier: "showProfileRegister", sender: sender)
                        }
                    }
        }

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ProfileViewController {
            
            let vc = segue.destination as? ProfileViewController
            vc?.userData = myUser
        }
        
    }
    
    @IBAction func backBarItem(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    func addUserDetails() {

        let uid = Auth.auth().currentUser?.uid
        if uid != nil {

//            let docData: [String: Any] = [
//              "first": firstNameField.text!,
//              "last": lastNameField.text!,
//                     "age":  ageField.text!,
//                     "email": emailField.text!,
//                     "id": uid!,
//                     "profilePicRef":"empty"
//                     ]
            
            myUser = UserData(first: firstNameField.text!, last: lastNameField.text!, profilePic: "", email: emailField.text!, uid: uid!, age: ageField.text!)

                  //   print("enter to add doc func")


            db.collection("Users").document(uid!).setData(myUser.toJson(),merge: true)
            

        }
        
    }
    
}
