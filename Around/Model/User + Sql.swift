//
//  User + Sql.swift
//  Around
//
//  Created by מאור ידין on 02/04/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import FirebaseAuth

extension UserData {
    
    static func create_table(database: OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS user (uid TEXT PRIMARY KEY,username TEXT, first TEXT, last TEXT, age TEXT, email TEXT,profilePicRef TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    static func create_table_url(database: OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS userDownloadURL (uid TEXT PRIMARY KEY,profileDownlaodURL TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
        static func addToDb(user:UserData){

         var sqlite3_stmt: OpaquePointer? = nil
         if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO user (uid, username, first, last, age, email, profilePicRef) VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            
            sqlite3_bind_text(sqlite3_stmt, 1, (user.uid as NSString).utf8String,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, (user.username as NSString).utf8String,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, (user.first as NSString).utf8String,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, (user.last as NSString).utf8String,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, (user.age as NSString).utf8String,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, (user.email as NSString).utf8String,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, (user.profilePicRef as NSString).utf8String,-1,nil);

             if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                 print("new row added succefully")
             }
         }
            
         sqlite3_finalize(sqlite3_stmt)
     }
     
     static func getUserFromDb()->UserData?{
         var sqlite3_stmt: OpaquePointer? = nil
        var user:UserData? = nil
         
        if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from user where uid = ?;",-1,&sqlite3_stmt,nil)
             == SQLITE_OK){
            
            sqlite3_bind_text(sqlite3_stmt, 1, (Auth.auth().currentUser!.uid as NSString).utf8String,-1,nil);
            
             while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                user = UserData()
                user?.uid = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                user?.username = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                user?.first = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                user?.last = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                user?.age = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
                user?.email = String(cString:sqlite3_column_text(sqlite3_stmt,5)!)
                user?.profilePicRef = String(cString:sqlite3_column_text(sqlite3_stmt,6)!)
 
            }
         }
         sqlite3_finalize(sqlite3_stmt)
         return user
     }
        
        static func deleteByTime(time:String){
            var sqlite3_stmt: OpaquePointer? = nil
            if (sqlite3_prepare_v2(ModelSql.instance.database,"DELETE FROM posts WHERE time = ?;",-1,&sqlite3_stmt,nil)
                == SQLITE_OK){
                        sqlite3_bind_text(sqlite3_stmt, 1, (time as NSString).utf8String,-1,nil);
                if sqlite3_step(sqlite3_stmt) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
                }
            sqlite3_finalize(sqlite3_stmt)

            }
    
    static func addToDbDownloadURL(downloadURL:String){

        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO userDownloadURL(uid, profileDownlaodURL) VALUES (?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
           
           
            sqlite3_bind_text(sqlite3_stmt, 1, (FireBaseManager.user!.uid as NSString).utf8String,-1,nil);
            print(downloadURL)
           sqlite3_bind_text(sqlite3_stmt, 2, (downloadURL as NSString).utf8String,-1,nil);

            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
           
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getDownloadURLfromDb()->String?{
        var sqlite3_stmt: OpaquePointer? = nil
        var url:String? = nil
        
       if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT profileDownlaodURL from userDownloadURL where uid = ?;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
        sqlite3_bind_text(sqlite3_stmt, 1, (Auth.auth().currentUser!.uid as NSString).utf8String,-1,nil)
        
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                url = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)

        }
        }
        sqlite3_finalize(sqlite3_stmt)
        return url
    }
    
}
