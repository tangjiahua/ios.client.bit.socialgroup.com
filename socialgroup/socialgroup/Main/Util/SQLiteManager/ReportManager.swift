//
//  ReportManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/23.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ReportManagerDelegate:NSObjectProtocol{
    
}

struct ReportedCircleModel {
    var circle_id:Int
}

struct ReportedBroadcastModel {
    var broadcast_id:Int
}

struct ReportedUserModel {
    var user_id:Int
    var avatar:Int
    var nickname:String
}

class ReportManager{
    
    static let manager = ReportManager()
    
    private var sqliteManager = SQLiteManager.manager
    
    var delegate:ReportManagerDelegate?
    
    
    // MARK:- Circle被举报的
    public func getReportedCircle() -> [ReportedCircleModel]{
        var circles:[ReportedCircleModel] = []
        
        let jsons = sqliteManager.searchReportedCircleTable(limit: nil, offset: nil)
        
        for json in jsons{
            circles.append(ReportedCircleModel(circle_id: json["circle_id"].intValue))
            
        }
        
        return circles
        
    }
    
    public func addReportedCircle(circle_id:Int){
        let json:JSON = ["circle_id":circle_id]
        
        sqliteManager.insertReportedCircleTable(item: json)
        
    }
    
    // MARK:- Broadcast被举报的
    public func getReportedBroadcast() -> [ReportedBroadcastModel]{
        var broadcasts:[ReportedBroadcastModel] = []
        
        let jsons = sqliteManager.searchReportedBroadcastTable(limit: nil, offset: nil)
        
        for json in jsons{
            broadcasts.append(ReportedBroadcastModel(broadcast_id: json["broadcast_id"].intValue))
            
        }
        
        return broadcasts
        
    }
    
    public func addReportedBroadcast(broadcast_id:Int){
        let json:JSON = ["broadcast_id":broadcast_id]
        
        sqliteManager.insertReportedBroadcastTable(item: json)
        
    }
    
    // MARK:- 用户被举报的
    public func getReportedUser() -> [ReportedUserModel]{
        var users:[ReportedUserModel] = []
        
        let jsons = sqliteManager.searchReportedUserTable(limit: nil, offset: nil)
        
        for json in jsons{
            users.append(ReportedUserModel(user_id: json["user_id"].intValue, avatar: json["avatar"].intValue, nickname: json["nickname"].stringValue))
            
        }
        return users
    }
    
    public func addReportedUser(user_id:Int, avatar:Int, nickname:String){
        let json:JSON = ["user_id":user_id, "avatar":avatar, "nickname":nickname]
        
        sqliteManager.insertReportedUserTable(item: json)
        
    }
    
    public func removeReportedUser(user_id:Int){
        sqliteManager.deleteReportedUserTable(user_id: user_id)
    }
    
}
