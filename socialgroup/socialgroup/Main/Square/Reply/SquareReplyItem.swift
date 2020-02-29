//
//  SquareReplyItem.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
class SquareReplyItem{
    
    var square_item_type:String!
    var square_item_id:String
    var comment_id:String!
    
    
    var reply_id:String!
    var reply_from_user_id:String!
    var nickname:String
    var avatar:String!
    var reply_to_user_id:String!
    var reply_to_user_nickname:String!
    var content:String!
    var create_date:String!
    
    init(square_item_type:String,square_item_id:String, comment_id:String, reply_id:String,reply_from_user_id:String, nickname:String, avatar:String, reply_to_user_id:String, reply_to_user_nickname:String, content:String, create_date:String) {
        self.square_item_type = square_item_type
        self.square_item_id = square_item_id
        self.comment_id = comment_id
        self.reply_id = reply_id
        
        self.reply_from_user_id = reply_from_user_id
        self.nickname = nickname
        self.avatar = avatar
        self.reply_to_user_id = reply_to_user_id
        self.reply_to_user_nickname = reply_to_user_nickname
        self.content = content
        self.create_date = create_date
    }
}
