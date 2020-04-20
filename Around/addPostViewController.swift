//
//  addPostViewController.swift
//  Around
//
//  Created by מאור ידין on 24/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class addPostViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var postBtn: UIButton!
    
    var post:Post?
    var db:Firestore!
    
    let locationManager = CLLocationManager()
    var imagePicker:UIImagePickerController!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add image
        imageView.layer.borderColor = UIColor.init(hexString: "006FFB").cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 8
        
        // content field
        contentView.layer.cornerRadius = 8
        
        // post button
        postBtn.layer.cornerRadius =  postBtn.frame.size.height/2
        postBtn.layer.masksToBounds = true
        let lightBlue = UIColor.init(hexString: "006FFB")
        let darkBlue = UIColor.init(hexString: "0053F5")
        postBtn.setGradientLayer(colorOne: lightBlue, colorTwo: darkBlue)
        
         let settings = FirestoreSettings()
        post = Post(uid: FireBaseManager.user!.uid,username: "", text: "",imageRef: "", time: "",lat: 0,long: 0)

        Firestore.firestore().settings = settings
          // [END setup]
        db = Firestore.firestore()
        
        let imageTap = UITapGestureRecognizer(target:self,action: #selector(openImagePicker))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageTap)
        imageView.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true;
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }

    @objc func openImagePicker(_ sender:Any) {
        //locationManager.startUpdatingLocation()
          self.present(imagePicker,animated: true,completion: nil)
      }
    

     @IBAction func PostActionButtom_clicked(_ sender: Any) {

        let loc =  LocationService.sharedInstance.locationManager.location
        let lat = loc!.coordinate.latitude
        let long = loc!.coordinate.longitude
        let currentDate = NSDate.now
        post?.text = "\(contentTextField.text!)"
        post?.username = FireBaseManager.user!.username
        post?.time = currentDate.timeIntervalSince1970.description
        post?.imageRef = ("account/\(post!.uid)/posts/\(post!.time)/postImage.jpeg")
        post?.lat = lat
        post?.long = long
                if let data = self.imageView.image?.jpegData(compressionQuality: 0.75) {
            
                    print("profile image is compressed")
                    let ref = FireBaseManager.getRef(path: post?.imageRef)
                    FireBaseManager.uploadFile(data: data, ref: ref,completion: {
                        
                        self.db.collection("Posts").document("\(self.post!.uid)_\(self.post!.time)").setData((self.post!.toJson()), merge: false, completion: nil)
})
                    }
                    print("collection is created")
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


    }

}

extension addPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //check if image picker has been canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        
        print("a new photo has been choosed")
        
        if (self.imageView.image?.jpegData(compressionQuality: 0.75)) != nil {
            
//            let ref = FireBaseManager.getRef(path: userData?.profilePicRef)
////            FireBaseManager.uploadFile(data: data, ref: ref, completion: getDocumentAndSetData)
//
//            FireBaseManager.uploadFile(data: data, ref: ref,completion: getDocumentAndSetData)
//
//
//
                
            }
        }
}
