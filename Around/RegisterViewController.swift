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

    // field views
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var firstnameView: UIView!
    @IBOutlet weak var lastnameView: UIView!
    
    // fields
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fieldRadius = 8
        let buttonRadius = 4
        emailView.layer.cornerRadius = CGFloat(fieldRadius)
        passwordView.layer.cornerRadius = CGFloat(fieldRadius)
        usernameView.layer.cornerRadius = CGFloat(fieldRadius)
        ageView.layer.cornerRadius = CGFloat(fieldRadius)
        firstnameView.layer.cornerRadius = CGFloat(fieldRadius)
        lastnameView.layer.cornerRadius = CGFloat(fieldRadius)
        registerBtn.layer.cornerRadius = CGFloat(buttonRadius)
    }
    
    
    @IBAction func registerOnClick(_ sender: Any) {
        
        if(usernameField.text != nil && emailField.text != nil && passwordField.text != nil && ageField.text != nil && firstNameField.text != nil && lastNameField.text != nil){
            myUser = UserData(first: firstNameField.text!, last: lastNameField.text!, profilePic: "", email: emailField.text!, uid: "", age: ageField.text!, username: usernameField.text!)
            
            FireBaseManager.CreateAccount(email: emailField.text!, password: passwordField.text!,_user:myUser) {
                        (result:String) in
                DispatchQueue.main.async{
                    FireBaseManager.Login(email: self.emailField.text!, password: self.passwordField.text!) { (success:Bool) in
                        
                        if(success){
                            print("success login from register")
                            self.addDefaultImageAndSegue()

                        }
                        
                        else {
                            print("error register")
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

    func addDefaultImageAndSegue() {

        let uid = Auth.auth().currentUser?.uid
        imageView.image = UIImage(named:"profileImage")
    
        print("compressing image..")
        if let data = self.imageView.image?.jpegData(compressionQuality: 0.75) {
    
            print("profile image is compressed")
              let ref = FireBaseManager.getRef(path: "account/\(uid!)/profileImage.jpeg")
            FireBaseManager.uploadFile(data: data, ref: ref,completion: {
                self.performSegue(withIdentifier: "profileSegue", sender: self)

            })}
            print("collection is created")
        }
    
    }
    
