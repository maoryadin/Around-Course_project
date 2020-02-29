//
//  PostManager.swift
//  Around
//
//  Created by מאור ידין on 24/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase


class PostManager: NSObject {
    static let databaseRef = Database.database().reference()
    static var posts = [Post]()
    var db:Firestore!
    let settings = FirestoreSettings()



    
    static func fillPosts(uid:String?,toId:String,completion:@escaping(_ result:String) -> Void) {
//        posts = []
//        let allPost = databaseRef.child("Posts")
//        print(allPost)
//        let post = databaseRef.child("Posts").queryOrdered(byChild: "uid").queryEqual(toValue: FireBaseManager.currentUser?.uid).observe(.childAdded, with: {
//            snapshot in
//            print(snapshot)
//        })
//
//        databaseRef.child("Posts").queryOrdered(byChild: "uid").queryEqual(toValue: FireBaseManager.currentUser?.uid).observe(.childAdded, with:{
//            snapshot in
//            print(snapshot)
//            if let result = snapshot.value as? [String:AnyObject] {
//                let toIdCloud = result["time"]! as! String
//                let p = Post(username: result["username"] as! String, text: result["text"] as! String, time:  result["time"] as! String)
//
//                    PostManager.posts.append(p)
//            }
//            completion("")
//        })
    }
}

class Post {
    var uid:String = ""
    var username:String = ""
    var text:String = ""
    var imageRef: String = ""
    var time:String = ""
    
    init(uid:String,username:String,text:String,imageRef:String,time:String) {
        self.uid = uid
        self.username = username
        self.text = text
        self.imageRef = imageRef
        self.time = time
    }
    init(json:[String:Any]){
        
        self.uid = json["uid"]! as! String;
        self.username = json["username"]! as! String;
        self.text = json["text"]! as! String;
        self.imageRef = json["imageRef"]! as! String;
        self.time = json["time"]! as! String;

        
    }
    func toJson() -> [String:Any] {
        var json = [String:Any]();
        json["uid"] = uid
        json["username"] = username
        json["text"] = text
        json["imageRef"] = imageRef
        json["time"] = time
        
        return json;
    }
    
    func getImage(completion:(@escaping (UIImage) -> Void)) -> Void {
        
        //let imageRef = FireBaseManager.getRef(path: "Posts/\(uid)/\(time)")
        let imageRef2 = FireBaseManager.getRef(path: self.imageRef)
        let image = FireStoreManager.getImage(ref: imageRef2)
        
        completion(image!)
        //return res
        
    }
}
