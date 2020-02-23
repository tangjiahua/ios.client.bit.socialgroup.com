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
    
    var delegate:UserListManagerDelegate?
    
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
