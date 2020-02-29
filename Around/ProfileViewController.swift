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



class ProfileViewController: UIViewController, UITableViewDataSource {
    
    let queue = DispatchQueue.global()
    

    @IBOutlet weak var tb: UITableView!
    var db:Firestore!
    var userData:UserData?
       let cellId = "photoCell"
    var products : [Product] = [Product]()
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    var imagePicker:UIImagePickerController!
    var activityView:UIActivityIndicatorView!
    var email = Auth.auth().currentUser?.email
    let uid = Auth.auth().currentUser?.uid

    

    
        override func viewDidLoad() {
        super.viewDidLoad()
            createProductArray()
            tb.register(ProductCell.self, forCellReuseIdentifier: cellId)
          let settings = FirestoreSettings()
          Firestore.firestore().settings = settings
          db = Firestore.firestore()

         //getDocumentAndSetData()
            setData()
            
        let imageTap = UITapGestureRecognizer(target:self,action: #selector(openImagePicker))
        ProfileImageView.isUserInteractionEnabled = true
        ProfileImageView.addGestureRecognizer(imageTap)
        ProfileImageView.layer.cornerRadius = ProfileImageView.bounds.height / 2
        ProfileImageView.clipsToBounds = true

                
        imagePicker = UIImagePickerController()
          imagePicker.allowsEditing = true;
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

    }

    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    func setData() {
        print("setting data in profile")
        self.firstNameLabel.text = FireBaseManager.user?.first
        self.lastNameLabel.text = FireBaseManager.user?.last
        self.ageLabel.text = FireBaseManager.user?.age
        let imageRef = FireBaseManager.getRef(path:FireBaseManager.user?.profilePicRef)
         
                         imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                             if error != nil {
                                 print("error")
                             return
                           } else {
                                 print("setting image")
                             self.ProfileImageView.image = UIImage(data: data!)
                                self.tb.reloadData()
                           }
        }
    }
    
    private func getDocumentAndSetData() {
        //Get specific document from current user
        let docRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "")

        // Get data
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.userData = UserData(json: dataDescription!)
                self.firstNameLabel.text = self.userData?.first
                self.lastNameLabel.text = self.userData?.last
                self.ageLabel.text = self.userData?.age
                let imageRef = FireBaseManager.getRef(path:self.userData?.profilePicRef)
                
                                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                    if error != nil {
                                        print("error")
                                    return
                                  } else {
                                        print("setting image")
                                        self.ProfileImageView.image = UIImage(data: data!)
                                        self.tb.reloadData()
                                        let secondVC = self.tabBarController?.viewControllers![1] as! FeedViewController
                                        
                                        //secondVC.userData = self.userData
                                  }
                                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        }
        
        
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProductCell
        let currentLastItem = PostManager.posts[indexPath.row]
            cell.post = currentLastItem
        return cell
        }
        
        
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostManager.posts.count
        }
        
        func tableView(_ tableView: UITableView,
                       heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }

        func createProductArray() {
            
              let docRef = Firestore.firestore().collection(FireBaseManager.user!.uid)
//            docRef.getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let data = document.data()
//                        PostManager.posts.append(Post(json: data))
//                    }
//                }
//            }
            

            docRef.addSnapshotListener {doc,err in
                print("listener !")
                PostManager.posts.removeAll()
                for document in doc!.documents {
                    let data = document.data()
                    PostManager.posts.append(Post(json: data))
                }
                self.tb.reloadData()

            }
            
//            docRef.getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let data = document.data()
//                        PostManager.posts.append(Post(json: data))
//                    }
//                }
//            }

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
        

        
        if let data = self.ProfileImageView.image?.jpegData(compressionQuality: 0.75) {


            let ref = FireBaseManager.getRef(path: FireBaseManager.user?.profilePicRef)

//            FireBaseManager.uploadFile(data: data, ref: ref, completion: getDocumentAndSetData)
    
            FireBaseManager.uploadFile(data: data, ref: ref,completion: setData)


                
            }
        }

}
