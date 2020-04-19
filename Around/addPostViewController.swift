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

    var post:Post?
    var from:ProfileViewController?
    var postCell:PostCell?
    let locationManager = CLLocationManager()
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker:UIImagePickerController!
    var activityView:UIActivityIndicatorView!
    @IBOutlet weak var textPostField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let imageTap = UITapGestureRecognizer(target:self,action: #selector(openImagePicker))
          imageView.isUserInteractionEnabled = true
          imageView.addGestureRecognizer(imageTap)
          //imageView.layer.cornerRadius = imageView.bounds.height / 2
          imageView.clipsToBounds = true

                  
          imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true;
          imagePicker.sourceType = .photoLibrary
          imagePicker.delegate = self
        
        if postCell != nil{
            updatePost(post: postCell!)
        }
    }
    
    
    func updatePost(post:PostCell) {
        self.post = postCell?.post
        self.textPostField.text = self.post?.text
        var ref:StorageReference? = FireBaseManager.getRef(path: self.post?.imageRef)
        FireBaseManager.getImageFromStorage(ref: ref!){
            image in
        
            self.imageView.image = image
            
        }

        
    }
    
    @objc func openImagePicker(_ sender:Any) {
        //locationManager.startUpdatingLocation()
          self.present(imagePicker,animated: true,completion: nil)
      }
    
    
    
    func createNewPost() {
        
        let toPost:Post? = Post(uid: FireBaseManager.currentUser!.uid, username: FireBaseManager.user!.username, text: "", imageRef: "", time: "", lat: 0, long: 0)
     let loc =  LocationService.sharedInstance.locationManager.location
                let lat = loc!.coordinate.latitude
                let long = loc!.coordinate.longitude
                let currentDate = NSDate.now
                toPost?.text = "\(textPostField.text!)"
                toPost?.username = FireBaseManager.user!.username
                toPost?.time = currentDate.timeIntervalSince1970.description
                toPost?.imageRef = ("account/\(toPost!.uid)/posts/\(toPost!.time)/postImage.jpeg")
                toPost?.lat = lat
                toPost?.long = long
                        if let data = self.imageView.image?.jpegData(compressionQuality: 0.75) {
                    
                            print("profile image is compressed")
                            let ref = FireBaseManager.getRef(path: toPost?.imageRef)
                            FireBaseManager.uploadFile(data: data, ref: ref,completion: {
                                
                                FireBaseManager.db.collection("Posts").document("\(toPost!.uid)_\(toPost!.time)").setData((toPost!.toJson()), merge: false, completion: nil)
        })}
        
                  print("collection is created")
        self.dismiss(animated: true, completion: nil)
    }

     @IBAction func PostActionButtom_clicked(_ sender: Any) {
        

        if post == nil{
            createNewPost()
            return
        }

        
        let loc =  LocationService.sharedInstance.locationManager.location
        let lat = loc!.coordinate.latitude
        let long = loc!.coordinate.longitude
 //       let currentDate = NSDate.now
        post?.text = "\(textPostField.text!)"
        post?.username = FireBaseManager.user!.username
//        post?.time = currentDate.timeIntervalSince1970.description
        post?.imageRef = ("account/\(post!.uid)/posts/\(post!.time)/postImage.jpeg")
        post?.lat = lat
        post?.long = long
                if let data = self.imageView.image?.jpegData(compressionQuality: 0.75) {
            
                    print("profile image is compressed")
                    let ref = FireBaseManager.getRef(path: post?.imageRef)
                    FireBaseManager.uploadFile(data: data, ref: ref,completion: {
                        
                        FireBaseManager.db.collection("Posts").document("\(self.post!.uid)_\(self.post!.time)").updateData(self.post!.toJson(), completion: {(error) in
                            if error == nil {
                                    print("updated successfully")
                                Post.updateByTime(post: self.post!)
                                self.from?.filterList()
                            }
                            else{
                                print("error updating collection")
                            }
                        })
})}
        self.dismiss(animated: true, completion: nil)
                    print("collection is updated")
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
