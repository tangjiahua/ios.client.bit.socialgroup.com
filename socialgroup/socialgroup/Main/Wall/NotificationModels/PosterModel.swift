//
//  WallModels.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/3/1.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation

class PosterModel:NSObject, Codable{
    var notification_id:String!
    var user_id:String!
    var user_nickname:String!
    var user_avatar:String!
    var type:String!
    var create_date:String!
    
    var brief:String!
    var welcome:String!
    var holddate:String!
    var holdlocation:String!
    var holder:String!
    var detail:String!
    var link:String!
    
    init(notification_id:String, user_id:String, user_nickname:String, user_avatar:String, type:String, create_date:String, brief:String, welcome:String, holddate:String, holdlocation:String, holder:String, detail:String, link:String) {
        self.notification_id = notification_id
        self.user_id = user_id
        self.user_nickname = user_nickname
        self.user_avatar = user_avatar
        self.type = type
        self.create_date = create_date
        self.brief = brief
        self.welcome = welcome
        self.holddate = holddate
        self.holdlocation = holdlocation
        self.holder = holder
        self.detail = detail
        self.link = link
        
        super.init()
    }
}
