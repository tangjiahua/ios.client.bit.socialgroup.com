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
    func receiveFetchSocialGroupListSuccessResponse()
    func receiveFetchSocialGroupListFailResponse(result: String, info: String)
    
    func receiveJoinSocialGroupSuccessResponse(result: String, info: String)
    func receiveJoinSocialGroupFailResponse(result: String, info: String)
}

class ChooseSocialGroupModel{
    
    var userId:String?
    var password:String?
    var socialGroupId:String?
    private var api = NetworkManager.SERVER_API_URL + "socialgroup_manager"
    var socialGroupList:[SocialGroupItem] = []
    
    weak var delegate:ChooseSocialGroupModelDelegate?
    
    init(_ userId:String, _ password: String) {
        self.userId = userId
        self.password = password
    }
    
    //MARK:- send request
    public func sendFetchSocialGroupListRequest(){
        let parameters:Parameters = ["method":"fetch", "user_id":userId!, "password":password!]
        Alamofire.request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        //拉取成功
                        let info = json["info"].array!
                        self.addSocialGroupItems(info)
                    }else{
                        //拉取失败
                        let info = json["info"].string!
                        self.delegate?.receiveFetchSocialGroupListFailResponse(result: "0", info: info)
                    }
                }
            case .failure(let error):
                print(error)
                self.delegate?.receiveFetchSocialGroupListFailResponse(result: "0", info: "response failure")
            }
        }
        
    }
    
    public func sendJoinSocialGroupRequest(_ socialGroupId:String){
        let parameters:Parameters = ["method":"join", "socialgroup_id":socialGroupId, "user_id":userId!, "password":password!]
        Alamofire.request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    let info = json["info"].string!
                    if(result.equals(str: "1")){
                        self.socialGroupId = socialGroupId
                        self.delegate?.receiveJoinSocialGroupSuccessResponse(result: "1", info: info)
                    }else{
                        self.delegate?.receiveJoinSocialGroupFailResponse(result: "0", info: info)
                    }
                }
            case .failure:
                self.delegate?.receiveJoinSocialGroupFailResponse(result: "0", info: "response error")
            }
        }
    }
    
    
    // 添加收取到的数据进模型
    private func addSocialGroupItems(_ info: [JSON]){
        for json in info{
            let id = json["socialgroup_id"].string!
            let name = json["socialgroup_name"].string!
            let avatar = json["socialgroup_avatar"].string!
            
            let item = SocialGroupItem(name: name, avatar: avatar, socialgroupId: id)
            socialGroupList.append(item)
        }
        
        self.delegate?.receiveFetchSocialGroupListSuccessResponse()
        
    }
}
