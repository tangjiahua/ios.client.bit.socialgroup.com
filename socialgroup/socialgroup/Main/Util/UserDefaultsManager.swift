//
//  UserDefaultsManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
class UserDefaultsManager{
    
    static let userDefaults = UserDefaults.standard
    
    static public func setBasicUserInfo(_ userId:String, _ password: String, _ socialGroupId: String){
        userDefaults.set(userId, forKey: "userId")
        userDefaults.set(password, forKey: "password")
        userDefaults.set(socialGroupId, forKey: "socialGroupId")
    }
    
    static public func getBasicUserInfo() -> Dictionary<String, String>{
        var basicUserInfoDic:Dictionary<String, String> = [:]
        basicUserInfoDic = ["userId":userDefaults.string(forKey: "userId")!, "password":userDefaults.string(forKey: "password")!, "socialGroupId":userDefaults.string(forKey: "socialGroupId")!]
        return basicUserInfoDic
    }
    
    static public func getIsLoginInfo() -> Bool{
        return userDefaults.bool(forKey: "isLogin")
    }
    
    static public func setLoginInfo(){
        userDefaults.set(true, forKey: "isLogin")
    }
    
    static public func setLogoutInfo(){
        userDefaults.set(false, forKey: "isLogin")
    }
}
