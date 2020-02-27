//
//  SquareCommentItem.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/27.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
class SquareCommentItem{
    
    var square_item_type:String!
    var comment_id:String!
    var user_id:String!
    var user_nickname:String
    var user_avatar:String!
    var content:String!
    var create_date:String!
    var reply_count:String!
    
    init(square_item_type:String, comment_id:String, user_id:String, user_nickname:String, user_avatar:String, content:String, create_date:String, reply_count:String) {
        self.square_item_type = square_item_type
        self.comment_id = comment_id
        self.user_id = user_id
        self.user_nickname = user_nickname
        self.user_avatar = user_avatar
        self.content = content
        self.create_date = create_date
        self.reply_count = reply_count
    }
}
