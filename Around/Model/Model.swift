//
//  Model.swift
//  Around
//
//  Created by shany_1568@yahoo.com on 26/03/2020.
//  Copyright © 2020 Around team. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class Model {
    static let instance = Model()
    
    var postsArray: [Post] = []
    
    var posts:ProfileViewController = ProfileViewController()
    
    
    private init(){
    }
    
    
//    func getAllPosts(callback:@escaping ([Post]?)->Void){
//         let docRef = Firestore.firestore().collection("Posts")
//                    docRef.addSnapshotListener {doc,err in
//                        print("listener !")
//                        PostManager.posts.removeAll()
//                        for document in doc!.documents {
//                            let data = document.data()
//                            let p = Post(json: data)
//                            if(p.uid == Auth.auth().currentUser?.uid){
//                                PostManager.posts.append(Post(json: data))
//                            }
//                        }
//                    }
//        for post in PostManager.posts
//        {
//            post.addToDb()
//        }
//        let finalData = Post.getAllPostsFromDb()
//        callback(finalData);
//        
//        print("\(Post.getAllPostsFromDb())")
//    }

    
}
class ModelEvents{
    static let PostDataEvent = EventNotificationBase(eventName: "com.assaf.PostDataEvent");
    private init(){}
}

class EventNotificationBase{
    let eventName:String;
    
    init(eventName:String){
        self.eventName = eventName;
    }
    
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(eventName),
                                 object: nil, queue: nil) { (data) in
                                                callback();
        }
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(eventName),
                                        object: self,
                                        userInfo: nil);
    }
}
