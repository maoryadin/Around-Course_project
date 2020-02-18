//
//  ProfileViewController.swift
//  Around
//
//  Created by מאור ידין on 16/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {

    var db:Firestore!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    var imagePicker:UIImagePickerController!
    var activityView:UIActivityIndicatorView!
    var username = Auth.auth().currentUser?.email
    let uid = Auth.auth().currentUser?.uid
    
    

    
        override func viewDidLoad() {
        super.viewDidLoad()
            
                        // [START setup]
           let settings = FirestoreSettings()
        
          Firestore.firestore().settings = settings
            // [END setup]
          db = Firestore.firestore()
            
            addDoc()

        
        if let User = Auth.auth().currentUser {
            profileNameLabel.text = User.email
        }
            
         setProfileimage()

        // Do any additional setup after loading the view.
        
        let imageTap = UITapGestureRecognizer(target:self,action: #selector(openImagePicker))
        ProfileImageView.isUserInteractionEnabled = true
        ProfileImageView.addGestureRecognizer(imageTap)
        ProfileImageView.layer.cornerRadius = ProfileImageView.bounds.height / 2
        ProfileImageView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
                
        imagePicker = UIImagePickerController()
          imagePicker.allowsEditing = true;
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

    }

    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    func setProfileimage() {
        
        let imageRef = FireBaseManager.getRef(path: "account/\(uid!)/profileImage.jpeg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("error")
            // Uh-oh, an error occurred!
            return
          } else {
            // Data for "images/island.jpg" is returned
                print("setting image")
            self.ProfileImageView.image = UIImage(data: data!)
          }
        }
    }
    
    func addDoc() {
        
        
      let docData: [String: Any] = [
               "first": "maor",
               "last": "yadin",
               "age": 25,
               "email": username!,
               "id": uid!,
               "profilePicRef":FireBaseManager.getRef(path: "account/\(uid!)/profileImage.jpeg").fullPath
               ]
               
               print("enter to add doc func")
               
               
        db.collection("Users").document(uid!).setData(docData,merge: true)
        
    }

}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //check if image picker has been canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.ProfileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        
        print("a new photo has been choosed")
        
        if let data = self.ProfileImageView.image?.jpegData(compressionQuality: 0.75) {
            
            let ref = FireBaseManager.getRef(path: "account/\(uid!)/profileImage.jpeg")
            FireBaseManager.uploadFile(data: data, ref: ref)
            
        }
        
    }
    
}
