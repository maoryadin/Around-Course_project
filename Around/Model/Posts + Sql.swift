//
//  Posts + Sql.swift
//  Around
//
//  Created by shany_1568@yahoo.com on 23/03/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation
import FirebaseAuth
extension Post{
    
static func create_table(database: OpaquePointer?){
    var errormsg: UnsafeMutablePointer<Int8>? = nil
    let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS posts (time TEXT PRIMARY KEY,uid TEXT, username TEXT, text TEXT, imageref TEXT,lat INTEGER,long INTEGER)", nil, nil, &errormsg);
    if(res != 0){
        print("error creating table");
        return
    }
}

    static func addToDb(post:Post){

     var sqlite3_stmt: OpaquePointer? = nil
     if (sqlite3_prepare_v2(ModelSql.instance.database,"INSERT OR REPLACE INTO posts(time, uid, username, text, imageRef, lat, long) VALUES (?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
        
        
        sqlite3_bind_text(sqlite3_stmt, 1, (post.time as NSString).utf8String,-1,nil);
        sqlite3_bind_text(sqlite3_stmt, 2, (post.uid as NSString).utf8String,-1,nil);
        sqlite3_bind_text(sqlite3_stmt, 3, (post.username as NSString).utf8String,-1,nil);
        sqlite3_bind_text(sqlite3_stmt, 4, (post.text as NSString).utf8String,-1,nil);
        sqlite3_bind_text(sqlite3_stmt, 5, (post.imageRef as NSString).utf8String,-1,nil);
        sqlite3_bind_double(sqlite3_stmt, 6, post.lat);
        sqlite3_bind_double(sqlite3_stmt, 7, post.long);

         if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
             print("new row added succefully")
         }
     }
        
     sqlite3_finalize(sqlite3_stmt)
 }
 
 static func getAllPostsFromDb()->[Post]{
     var sqlite3_stmt: OpaquePointer? = nil
     var data = [Post]()
     
    if (sqlite3_prepare_v2(ModelSql.instance.database,"SELECT * from posts where uid = ?;",-1,&sqlite3_stmt,nil)
         == SQLITE_OK){
        
        sqlite3_bind_text(sqlite3_stmt, 1, (Auth.auth().currentUser!.uid as NSString).utf8String,-1,nil);

         while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
            let post:Post = Post()
            post.time = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
            post.uid = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
             post.username = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
             post.text = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
             post.imageRef = String(cString:sqlite3_column_text(sqlite3_stmt,4)!)
            post.lat = sqlite3_column_double(sqlite3_stmt,5)
            post.long = sqlite3_column_double(sqlite3_stmt,6)

            
             data.append(post)
         }
     }
     sqlite3_finalize(sqlite3_stmt)
     return data
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
    }
 
