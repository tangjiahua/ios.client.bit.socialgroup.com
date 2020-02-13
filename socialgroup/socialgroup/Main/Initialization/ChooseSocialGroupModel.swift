//
//  SocialGroupModel.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/13.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SocialGroupItem {
    var name:String!
    var avatar:String!
    var socialgroupId:String!
    
}

protocol ChooseSocialGroupModelDelegate: NSObjectProtocol {
    func receiveFetchSocialGroupListSuccessResponse(result: String, info: String)
    func receiveFetchSocialGroupListFailResponse(result: String, info: String)
    
    func receiveJoinSocialGroupSuccessResponse(result: String, info: String)
    func receiveJoinSocialGroupFailResponse(result: String, info: String)
}

class ChooseSocialGroupModel{
    
    var userId:String?
    var password:String?
    
    private var api = NetworkManager.SERVER_API_URL + "socialgroup_manager"
    
    var socialGroups:[SocialGroupItem] = []
    
    init(_ userId:String, _ password: String) {
        self.userId = userId
        self.password = password
    }
    
    //MARK:- send request
    public func sendFetchSocialGroupListRequest(){
        let parameters:Parameters = ["method":"fetch", "useri_d":userId, "password":password]
        
    }
}
