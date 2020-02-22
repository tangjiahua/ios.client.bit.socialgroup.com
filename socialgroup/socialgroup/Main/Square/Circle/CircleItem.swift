//
//  CircleItem.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/22.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
class CircleItem {
    var circle_id:Int!
    var user_id:Int!
    var user_nickname:String!
    var user_avatar:Int!
    var type:Int!
    var content:String!
    var create_date:String!
    var comment_count:Int!
    var like_count:Int!
    var picture_count:Int!
    
    var isLiked:Bool = false
    
    init(circle_id:Int,user_id:Int, user_nickname:String, user_avatar:Int, type:Int, content:String, create_date:String, comment_count:Int, like_count:Int, picture_count:Int) {
        self.circle_id = circle_id
        self.user_id = user_id
        self.user_nickname = user_nickname
        self.user_avatar = user_avatar
        self.type = type
        self.content = content
        self.create_date = create_date
        self.comment_count = comment_count
        self.like_count = like_count
        self.picture_count = picture_count
    }
}
