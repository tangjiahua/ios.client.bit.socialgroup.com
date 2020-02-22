//
//  BroadcastItem.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/22.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
class BroadcastItem {
    var broadcast_id:Int!
    var type:Int!
    var title:String!
    var content:String!
    var create_date:String!
    var comment_count:Int!
    var like_count:Int!
    var dislike_count:Int!
    var picture_count:Int!
    
    var isLiked:Bool = false
    var isDisliked:Bool = false
    
    init(broadcast_id:Int, type:Int, title:String, content:String, create_date:String, comment_count:Int, like_count:Int, dislike_count:Int, picture_count:Int) {
        self.broadcast_id = broadcast_id
        self.type = type
        self.title = title
        self.content = content
        self.create_date = create_date
        self.comment_count = comment_count
        self.like_count = like_count
        self.dislike_count = dislike_count
        self.picture_count = picture_count
    }
}
