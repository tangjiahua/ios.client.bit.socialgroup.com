//
//  SquareJudgeItem.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//


import Foundation
class SquareJudgeItem{
    
    var judge_type:String!
    var judge_id:String!
    var user_id:String!
    var user_nickname:String
    var user_avatar:String!
    
    init(judge_type:String, judge_id:String, user_id:String, user_nickname:String, user_avatar:String) {
        self.judge_type = judge_type
        self.judge_id = judge_id
        self.user_id = user_id
        self.user_nickname = user_nickname
        self.user_avatar = user_avatar
    }
}
