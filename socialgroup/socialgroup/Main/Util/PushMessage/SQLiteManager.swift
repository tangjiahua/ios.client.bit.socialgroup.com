//
//  SQLiteManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/15.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit
import SQLite
import SwiftyJSON


//MARK:- push_massage_table
let push_message_row_id = Expression<Int>("id")
let push_message_id = Expression<Int>("push_message_id")
let push_message_type = Expression<Int>("type")
let push_message_content = Expression<String>("content")
let push_message_create_date = Expression<String>("create_date")


//MARK:- SQLiteManager
class SQLiteManager: NSObject {
    
    static let manager = SQLiteManager()
    private var db: Connection?
    private var table: Table?
    
    private func getDB() -> Connection {
        
        if db == nil {
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            db = try! Connection("\(path)/db.sqlite3")
            
            db?.busyTimeout = 5.0
            
        }
        print(NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!)
        return db!
        
    }
    
    private func getPushMessageTable() -> Table {
        
        if table == nil {
            
            table = Table("push_message")
            
            try! getDB().run(
                table!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                    builder.column(push_message_row_id, primaryKey: .autoincrement)
                    builder.column(push_message_id)
                    builder.column(push_message_type)
                    builder.column(push_message_content)
                    builder.column(push_message_create_date)
                    
                })
            )
            
        }
        return table!
        
    }
    
    //增
    func insertPushMessageTable(item: JSON) {
        
        let insert = getPushMessageTable().insert(push_message_id <- item["push_message_id"].intValue, push_message_type <- item["type"].intValue, push_message_content <- item["content"].stringValue, push_message_create_date <- item["create_date"].stringValue)
        print("插入 id: \(String(describing: item["push_message_id"].int)), date: \(String(describing: item["create_date"].string))")
        if let rowId = try? getDB().run(insert) {
            print("插入成功：\(rowId)")
        } else {
            print("插入失败")
        }
        
    }
    
    
    
    
    
    func searchPushMessage(limit:Int?, offset:Int?) -> [JSON]{
        var jsons:[JSON] = []
        for item in try! getDB().prepare(getPushMessageTable().order(push_message_id.desc)){
            
            print("读取：\(item[push_message_id]), \(item[push_message_create_date])")
            let model:JSON = ["push_message_id": item[push_message_id], "type": item[push_message_type], "content": item[push_message_content], "create_date": item[push_message_create_date]]
            jsons.append(model)
            
        }
        return jsons
        
        
    }
    
}
