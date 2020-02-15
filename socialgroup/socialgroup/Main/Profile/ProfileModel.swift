//
//  ProfileModel.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
class ProfileModel{
    
    var avatar:String!
    var background:String!
    var stickCount:String!
    var nickname:String!
    var realname:String!
    var gender:String!
    var age:String!
    var wallPhotosCount:String!
    var grade:String!
    var hometown:String!
    var major:String!
    var relationshipStatus:String!
    var publicIntroduce:String!
    var privateIntroduce:String!
    
    var isPrivateAbleToSee:Bool!
    
    public func setProfileModel(){
        avatar = "placeholder"
        background = "girls"
        stickCount = "99"
        nickname = "thomas"
        realname = "汤佳桦"
        gender = "m"
        age = "20"
        wallPhotosCount = "5"
        grade = "2017"
        hometown = "重庆"
        major = "计算机科学与技术"
        relationshipStatus = "恋爱"
        publicIntroduce = "z公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区公共介绍区"
        privateIntroduce = "私密介绍区"
        isPrivateAbleToSee = true
    }
    
    
}
