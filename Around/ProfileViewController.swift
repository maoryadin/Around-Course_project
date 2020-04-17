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
import Kingfisher
import CoreLocation

class ProfileViewController: UIViewController {
    @IBOutlet weak var addPostBtn: UIBarButtonItem!
    
    @IBOutlet weak var signOutBtn: UIBarButtonItem!
    
    @IBOutlet weak var tb: UITableView!
    var db:Firestore!
    var userData:UserData?
    let cellId = "photoCell"
    //var products : [Product] = [Product]()
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    var imagePicker:UIImagePickerController!
    var activityView:UIActivityIndicatorView!
    var email = Auth.auth().currentUser?.email
    var uid = Auth.auth().currentUser?.uid
    var postsRef:CollectionReference? = Firestore.firestore().collection("Posts")
    var ref:StorageReference? = FireBaseManager.getRef(path: FireBaseManager.user?.profilePicRef)
    var listener:ListenerRegistration?
    
        override func viewDidLoad() {
        super.viewDidLoad()
addPostBtn.image?.withRenderingMode(.alwaysOriginal)
signOutBtn.image?.withRenderingMode(.alwaysOriginal)
            db = Firestore.firestore()
            let settings = FirestoreSettings()
            PostManager.posts.append(contentsOf: Post.getAllPostsFromDb())
            self.tb.reloadData()
            createProductArray()
            tb.register(PostCell.self, forCellReuseIdentifier: cellId)
          Firestore.firestore().settings = settings
        
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

    override func viewWillAppear(_ animated: Bool) {
    

    }
    
    override func viewWillDisappear(_ animated: Bool) {

        
    }


    @IBAction func SignOutAction(_ sender: Any) {

            do {
              try Auth.auth().signOut()
                let signInController = SignInViewController()
                let signInNavigationController = UINavigationController(rootViewController: signInController)
                let parent = self.parent!
                parent.dismiss(animated: true, completion: {
                    self.userData = nil
                    self.email = nil
                    self.uid = nil
                    self.postsRef = nil
                    self.ref = nil
                    self.listener?.remove()
                    self.present(signInNavigationController, animated: true, completion: nil)

                })
            } catch let err {
                print(err)
        }}

    func setData() {
        
        
        print("setting data in profile")
        self.firstNameLabel.text = FireBaseManager.user?.first
        self.lastNameLabel.text = FireBaseManager.user?.last
        self.ageLabel.text = FireBaseManager.user?.age
        
        initProfilePicCache()
    }
    
    func initProfilePicCache() {
        let urlDB = UserData.getDownloadURLfromDb()

        if (urlDB == nil) {

            ref!.downloadURL(completion: { url,error in
                if(error == nil){
                self.ProfileImageView.kf.setImage(with: url!)
                    UserData.addToDbDownloadURL(downloadURL: url!.absoluteString)
                }})
        } else {
            
            self.ProfileImageView.kf.setImage(with: URL(string: urlDB!))

        }
    }
        

    func createProductArray() {
            var latestTime:String = "0"
            if (PostManager.posts.count != 0)
            {
                latestTime = PostManager.posts.last!.time
            }
            
            listener =  postsRef!.whereField("uid", isEqualTo: FireBaseManager.user!.uid).whereField("time", isGreaterThan: latestTime).addSnapshotListener {querySnapshot,error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshot: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach{ diff in
                    
                    if(diff.type == .added){
                        if(PostManager.posts.contains(where: {$0.time.elementsEqual(diff.document["time"] as! String)})) {
                            return
                        }
                        let post:Post = Post(json: diff.document.data())
                   PostManager.posts.append(post)
                        Post.addToDb(post: post)
                        self.tb.reloadData()

                    }
                    
                    if(diff.type == .removed){
                        let time = diff.document["time"] as! String
                        PostManager.posts.removeAll {$0.time.elementsEqual(time)}
                        Post.deleteByTime(time: time)
                        self.tb.reloadData()

                    }
                }
            }
        
}


}

extension ProfileViewController: UITableViewDataSource
{
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let key = "\(PostManager.posts[indexPath.row].uid)_\(PostManager.posts[indexPath.row].time)"
            FireBaseManager.deleteFrom(collection: "Posts", document:key)
            Post.deleteByTime(time: PostManager.posts[indexPath.row].time)
            PostManager.posts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
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
}



extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    
    //check if image picker has been canceled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)
    }
    
    //image picker controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.ProfileImageView.image = pickedImage
            if let data = pickedImage.jpegData(compressionQuality: 0.75) {

                let currentDate = NSDate.now.timeIntervalSince1970.description

                 let newRef = FireBaseManager.getRef(path: "account/\(uid!)/profileImage_\(currentDate).jpeg")
                FireBaseManager.user?.profilePicRef = newRef.fullPath
                let hash = ["profilePicRef":newRef.fullPath]
                FireBaseManager.db.collection("Users").document(Auth.auth().currentUser!.uid).updateData(hash, completion: { err in
                    
           if err == nil {
    FireBaseManager.uploadFile(data: data, ref: newRef,completion: {
        newRef.downloadURL(completion: { url,error in
            print(url!.absoluteString)
            if(error == nil){
  //          self.ProfileImageView.kf.setImage(with: url!)
            UserData.addToDbDownloadURL(downloadURL: url!.absoluteString)
            }})
        
    })}})}
        }
        picker.dismiss(animated: true, completion: nil)
        

        }
}

