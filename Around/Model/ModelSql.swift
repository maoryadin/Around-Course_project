//
//  ModelSql.swift
//  Around
//
//  Created by shany_1568@yahoo.com on 22/03/2020.
//  Copyright © 2020 Around team. All rights reserved.
//

import Foundation

class ModelSql{
    var database: OpaquePointer? = nil
    static let instance = ModelSql()

    func connect(){
         let dbFileName = "database2.db"
         if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
         }
//        create()
        Post.create_table(database: database)
        UserData.create_table(database: database)
        UserData.create_table_url(database: database)
        
    }
    
    deinit {
        sqlite3_close_v2(database);
    }
    
}
