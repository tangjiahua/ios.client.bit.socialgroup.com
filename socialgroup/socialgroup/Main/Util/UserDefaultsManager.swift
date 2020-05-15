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
    
    static public func setBasicUserInfo(_ account:String, _ userId:String, _ password: String, _ socialGroupId: String){
        userDefaults.set(account, forKey: "account")
        userDefaults.set(userId, forKey: "user_id")
        userDefaults.set(password, forKey: "password")
        userDefaults.set(socialGroupId, forKey: "socialgroup_id")
    }
    
    static public func getBasicUserInfo() -> Dictionary<String, String>{
        var basicUserInfoDic:Dictionary<String, String> = [:]
        basicUserInfoDic = ["userId":userDefaults.string(forKey: "user_id")!, "password":userDefaults.string(forKey: "password")!, "socialGroupId":userDefaults.string(forKey: "socialgroup_id")!]
        return basicUserInfoDic
    }
    
    static public func deleteUserInfo(){
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics {
            userDefaults.removeObject(forKey: key.key)
        }
        userDefaults.synchronize()
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
    
    static public func setNewestPushMessageId(id:Int){
        userDefaults.set(id, forKey: "newestPushMessageId")
    }
    
    static public func setNewPushMessageCount(count: Int){
        userDefaults.set(count, forKey: "newPushMessageCount")
    }
    
    
    
    static public func getNewPushMessageCount() -> Int{
        return userDefaults.integer(forKey: "newPushMessageCount")
    }
    
    static public func getNewestPushMessageId() ->Int{
        return userDefaults.integer(forKey: "newestPushMessageId")
    }
    
    static public func getAccount() -> String{
        return userDefaults.string(forKey: "account")!
    }
    
    static public func getUserId() -> String {
        return userDefaults.string(forKey: "user_id")!
    }
    
    static public func getPassword() -> String {
        return userDefaults.string(forKey: "password")!
    }
    
    static public func getSocialGroupId() -> String{
        return userDefaults.string(forKey: "socialgroup_id")!
    }
    
    static public func getUserNickname() -> String{
        return userDefaults.string(forKey: "nickname") ?? "暂未填写"
    }
    
    static public func getRole() -> String{
        return userDefaults.string(forKey: "role") ?? "0"
    }
    
}
