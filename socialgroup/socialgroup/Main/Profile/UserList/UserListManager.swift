//
//  UserListManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/16.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct UserListModel {
    var user_profile_id:String!
    var user_id:String!
    var nickname:String!
    var realname:String!
    var gender:String!
    var avatar:String!
    var age:String!
}

protocol UserListManagerDelegate:NSObjectProtocol {
    func fetchStickToMeListSuccess(count:Int)
    func fetchStickToMeListFail(info: String)
}

class UserListManager{
    var model:[UserListModel] = []
    var userDefaults = UserDefaults.standard
    var fetchNoMore = false
    
    var delegate:UserListManagerDelegate?
    
    // MARK:- 拉取谁戳过我的网络请求
    func fetchStickToMeList(){
        let parameters:Parameters = ["socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!, "user_id":userDefaults.string(forKey: "user_id")!, "password":userDefaults.string(forKey: "password")!]
        
        Alamofire.request(NetworkManager.PROFILE_STICK_LIST_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        let array = json["info"].array!
                        for i in array{
                            var item = UserListModel()
                            item.user_profile_id = ""
                            item.user_id = i["user_id"].string!
                            item.nickname = i["nickname"].string!
                            item.realname = i["realname"].string!
                            item.gender = i["gender"].string!
                            item.avatar = i["avatar"].string!
                            item.age = i["age"].string!
                            self.model.append(item)
                        }
                        self.delegate?.fetchStickToMeListSuccess(count: array.count)
                        
                    }else{
                        self.delegate?.fetchStickToMeListFail(info: json["info"].string!)
                    }
                    
                }
            case.failure(let error):
                print(error)
                self.delegate?.fetchStickToMeListFail(info: "response .fail")
            }
        }
    }
    
    // MARK:- 拉取“发现”-“社交网络”的网络请求
    func fetchSocialNetsList(){
        let parameters:Parameters = ["socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!,"method":"1","user_profile_id":"0", "user_id":userDefaults.string(forKey: "user_id")!, "password":userDefaults.string(forKey: "password")!]
        
        Alamofire.request(NetworkManager.DISCOVER_MEMBERS_FETCH_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        let array = json["info"].array!
                        for i in array{
                            var item = UserListModel()
                            item.user_profile_id = i["user_profile_id"].string!
                            item.user_id = i["user_id"].string!
                            item.nickname = i["nickname"].string!
                            item.realname = i["realname"].string!
                            item.gender = i["gender"].string!
                            item.avatar = i["avatar"].string!
                            item.age = i["age"].string!
                            self.model.append(item)
                        }
                        self.delegate?.fetchStickToMeListSuccess(count: array.count)
                        
                    }else{
                        self.delegate?.fetchStickToMeListFail(info: json["info"].string!)
                    }
                    
                }
            case.failure(let error):
                print(error)
                self.delegate?.fetchStickToMeListFail(info: "response .fail")
            }
        }
    }
    
    // MARK:- 拉取“发现”-“社交网络”的网络请求
    func fetchOldSocialNetsList(){
        let parameters:Parameters = ["socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!,"method":"2","user_profile_id":model.last!.user_profile_id!, "user_id":userDefaults.string(forKey: "user_id")!, "password":userDefaults.string(forKey: "password")!]
        
        Alamofire.request(NetworkManager.DISCOVER_MEMBERS_FETCH_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        let array = json["info"].array!
                        for i in array{
                            var item = UserListModel()
                            item.user_profile_id = i["user_profile_id"].string!
                            item.user_id = i["user_id"].string!
                            item.nickname = i["nickname"].string!
                            item.realname = i["realname"].string!
                            item.gender = i["gender"].string!
                            item.avatar = i["avatar"].string!
                            item.age = i["age"].string!
                            self.model.append(item)
                        }
                        
                        if(array.count == 0){
                            self.fetchNoMore = true
                        }
                        
                        self.delegate?.fetchStickToMeListSuccess(count: array.count)
                        
                    }else{
                        self.delegate?.fetchStickToMeListFail(info: json["info"].string!)
                    }
                    
                }
            case.failure(let error):
                print(error)
                self.delegate?.fetchStickToMeListFail(info: "response .fail")
            }
        }
    }
    
    // MARK:- 拉取“发现”-“寻人启事”的网络请求
    /*
     {
     “socialgroup_id”:1,        //1代表北理社群
     “method”:1,        //1代表通过传入真实姓名来查找，我们暂时不做其他的搜索方法
     “info”:xxx        //具体的信息，真实姓名（字符串）
     
     “user_id”:xxx,
     “password”:xxx
     }
     */
    func fetchFindUserListBy(info:String, method: String){
        let parameters:Parameters = ["socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!,"method":method,"info":info, "user_id":userDefaults.string(forKey: "user_id")!, "password":userDefaults.string(forKey: "password")!]
        
        Alamofire.request(NetworkManager.DISCOVER_MEMBERS_SEARCH_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        let array = json["info"].array!
                        for i in array{
                            var item = UserListModel()
                            item.user_profile_id = ""
                            item.user_id = i["user_id"].string!
                            item.nickname = i["nickname"].string!
                            item.realname = i["realname"].string!
                            item.gender = i["gender"].string!
                            item.avatar = i["avatar"].string!
                            item.age = i["age"].string!
                            self.model.append(item)
                        }
                        self.delegate?.fetchStickToMeListSuccess(count: array.count)
                        
                    }else{
                        self.delegate?.fetchStickToMeListFail(info: json["info"].string!)
                    }
                    
                }
            case.failure(let error):
                print(error)
                self.delegate?.fetchStickToMeListFail(info: "response .fail")
            }
        }
    }
    
}
