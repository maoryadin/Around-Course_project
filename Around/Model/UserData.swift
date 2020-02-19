//
//  UserData.swift
//  Around
//
//  Created by מאור ידין on 19/02/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation

class UserData : NSObject {
    var username:String = ""
    var first:String = ""
    var profilePicRef:String = ""
    var age:String = ""
    var last:String = ""
    var email:String = ""
    var uid:String = ""

    
    func getUsername() -> String {
        return first
    }
    
    func getAge() -> String {
        return first
    }
    
    func getProfilePic() -> String {
        return first
    }
    
    
    init(first:String, last:String, profilePic:String, email:String, uid:String, age:String,username:String){
        self.first = first
        self.last = last
        self.profilePicRef = profilePic
        self.age = age
        self.email = email
        self.uid = uid
        self.username = username

    }
    
    
    
    init(json:[String:Any]){
        self.email = json["email"] as! String;
        self.first = json["first"] as! String;
        self.last = json["last"] as! String;
        self.profilePicRef = json["profilePicRef"] as! String;
        self.uid = json["id"] as! String;
        self.age = json["age"] as! String;
        self.username = json["username"] as! String;
        
    }
    
    func toJson() -> [String:Any] {
        var json = [String:String]();
        json["email"] = email
        json["first"] = first
        json["last"] = last
        json["profilePicRef"] = profilePicRef
        json["id"] = uid
        json["age"] = age
        json["username"] = username
        
        return json;
    }
    
    
}
