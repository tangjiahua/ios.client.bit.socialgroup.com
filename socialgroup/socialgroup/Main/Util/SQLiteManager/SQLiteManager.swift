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
let push_message_is_checked = Expression<Bool>("is_checked")

// MARK:- reportedBroadcastTable
let reported_broadcast_row_id = Expression<Int>("id")
let reported_broadcast_id = Expression<Int>("broadcast_id")


//MARK:- reportedCircleTable
let reported_circle_row_id = Expression<Int>("id")
let reported_circle_id = Expression<Int>("circle_id")

//MARK:- reportedUserTable
let reported_user_row_id = Expression<Int>("id")
let reported_user_id = Expression<Int>("user_id")
let reported_avatar = Expression<Int>("avatar")
let reported_nickname = Expression<String>("nickname")

//MARK:- SQLiteManager
class SQLiteManager: NSObject {
    
    static let manager = SQLiteManager()
    private var db: Connection?
    private var pushMessageTable: Table?
    private var reportedBroadcastTable: Table?
    private var reportedCircleTable: Table?
    private var reportedUserTable: Table?
    
    
    private func getDB() -> Connection {
        
        if db == nil {
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            db = try! Connection("\(path)/db.sqlite3")
            
            db?.busyTimeout = 5.0
            
        }
        return db!
        
    }
    
    public func disconnectDB(){
        pushMessageTable = nil
        db = nil
        
    }
    
    
    // MARK:- 推送消息的表
    private func getPushMessageTable() -> Table {
        
        if pushMessageTable == nil {
            
            pushMessageTable = Table("push_message\(UserDefaultsManager.getUserId())")
            
            try! getDB().run(
                pushMessageTable!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                    builder.column(push_message_row_id, primaryKey: .autoincrement)
                    builder.column(push_message_id)
                    builder.column(push_message_type)
                    builder.column(push_message_content)
                    builder.column(push_message_create_date)
                    builder.column(push_message_is_checked)
                })
            )
            
        }
        return pushMessageTable!
        
    }
    
    //增
    func insertPushMessageTable(item: JSON) {
        
        let insert = getPushMessageTable().insert(push_message_id <- item["push_message_id"].intValue, push_message_type <- item["type"].intValue, push_message_content <- item["content"].stringValue, push_message_create_date <- item["create_date"].stringValue, push_message_is_checked <- false)
//        print("插入 id: \(String(describing: item["push_message_id"].int)), date: \(String(describing: item["create_date"].string))")
        if let rowId = try? getDB().run(insert) {
            print("插入成功：\(rowId)")
        } else {
            print("插入失败")
        }
        
    }
    
    
    // 更新
        func updatePushMessageChecked(id: Int) -> Void {
            let item = getPushMessageTable().filter(push_message_id == id)
            
            do {
                if try getDB().run(item.update(push_message_is_checked <- true)) > 0 {
                    print("更新成功")
                } else {
                    print("没有发现 条目")
                }
            } catch {
                print("更新失败：\(error)")
            }
        }
    
    
    func searchPushMessage(limit:Int?, offset:Int?) -> [JSON]{
        var jsons:[JSON] = []
        for item in try! getDB().prepare(getPushMessageTable().order(push_message_id.desc)){
            
//            print("读取：\(item[push_message_id]), \(item[push_message_create_date])")
            let model:JSON = ["push_message_id": item[push_message_id], "type": item[push_message_type], "content": item[push_message_content], "create_date": item[push_message_create_date], "is_checked":item[push_message_is_checked]]
            
            jsons.append(model)
            
        }
        return jsons
        
        
    }
    
    // MARK:- 举报broadcast item的表
    private func getReportedBroadcastTable() -> Table {
            
        if reportedBroadcastTable == nil {
            
            reportedBroadcastTable = Table("reportedBroadcastTable\(UserDefaultsManager.getUserId())socialgroup_\(UserDefaultsManager.getSocialGroupId())")
            
            try! getDB().run(
                reportedBroadcastTable!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                    builder.column(reported_broadcast_row_id, primaryKey: .autoincrement)
                    builder.column(reported_broadcast_id)
                })
            )
            
        }
        return reportedBroadcastTable!
        
    }
        
        //增
        func insertReportedBroadcastTable(item: JSON) {
            
            let insert = getReportedBroadcastTable().insert(reported_broadcast_id <- item["broadcast_id"].intValue)
            if let rowId = try? getDB().run(insert) {
                print("插入成功：\(rowId)")
            } else {
                print("插入失败")
            }
            
        }
        
        
        
        func searchReportedBroadcastTable(limit:Int?, offset:Int?) -> [JSON]{
            var jsons:[JSON] = []
            for item in try! getDB().prepare(getReportedBroadcastTable()){
                
                let model:JSON = ["broadcast_id": item[reported_broadcast_id]]
                
                jsons.append(model)
                
            }
            return jsons
            
            
        }
    
    
    
    // MARK:- 举报circle item的表
    private func getReportedCircleTable() -> Table {
               
       if reportedCircleTable == nil {
           
           reportedCircleTable = Table("reportedCircleTable\(UserDefaultsManager.getUserId())socialgroup_\(UserDefaultsManager.getSocialGroupId())")
           
           try! getDB().run(
               reportedCircleTable!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                   builder.column(reported_circle_row_id, primaryKey: .autoincrement)
                   builder.column(reported_circle_id)
               })
           )
           
       }
       return reportedCircleTable!
       
   }
       
       //增
       func insertReportedCircleTable(item: JSON) {
           
           let insert = getReportedCircleTable().insert(reported_circle_id <- item["circle_id"].intValue)
           if let rowId = try? getDB().run(insert) {
               print("插入成功：\(rowId)")
           } else {
               print("插入失败")
           }
           
       }
       
       
       
       func searchReportedCircleTable(limit:Int?, offset:Int?) -> [JSON]{
           var jsons:[JSON] = []
           for item in try! getDB().prepare(getReportedCircleTable()){
               
               let model:JSON = ["circle_id": item[reported_circle_id]]
               
               jsons.append(model)
               
           }
           return jsons
           
           
       }
    
    // MARK:- 举报用户的表
    private func getReportedUserTable() -> Table {
                
        if reportedUserTable == nil {
            
            reportedUserTable = Table("reportedUserTable\(UserDefaultsManager.getUserId())")
            
            try! getDB().run(
                reportedUserTable!.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (builder) in
                    builder.column(reported_user_row_id, primaryKey: .autoincrement)
                    builder.column(reported_user_id, unique: true)
                    builder.column(reported_avatar)
                    builder.column(reported_nickname)
                })
            )
            
        }
        return reportedUserTable!
        
    }
        
        //增
        func insertReportedUserTable(item: JSON) {
            
            let insert = getReportedUserTable().insert(reported_user_id <- item["user_id"].intValue, reported_avatar <- item["avatar"].intValue, reported_nickname <- item["nickname"].stringValue)
            if let rowId = try? getDB().run(insert) {
                print("插入成功：\(rowId)")
            } else {
                print("插入失败")
            }
            
        }
    
    //删
    func deleteReportedUserTable(user_id:Int){
        let item = getReportedUserTable().filter(reported_user_id == user_id)
        do {
            if try! getDB().run(item.delete()) > 0 {
                print("删除成功")
            } else {
                print("删除失败")
                
            }
        }
    }
        
        
        
        func searchReportedUserTable(limit:Int?, offset:Int?) -> [JSON]{
            var jsons:[JSON] = []
            for item in try! getDB().prepare(getReportedUserTable()){
                
                let model:JSON = ["user_id": item[reported_user_id], "avatar": item[reported_avatar], "nickname":item[reported_nickname]]
                
                jsons.append(model)
                
            }
            return jsons
            
            
        }
    
}
