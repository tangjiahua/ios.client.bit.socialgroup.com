//
//  CircleManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/22.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CircleManagerDelegate:NSObjectProtocol {
    func CircleFetchSuccess(result:String, info:String)
    func CircleFetchFail(result:String, info:String)
    
    func likeItemSuccess(item:CircleItem, isToCancel:Bool)
    func likeItemFail(result:String, info: String, isToCancel:Bool)
    
    
    func reportItemSuccess(item:CircleItem)
    func reportItemFail(result:String, info: String)
    
    func managerDeleteItemSuccess(item:CircleItem)
    func managerDeleteItemFail(result:String, info: String)
    
    func deleteItemSuccess(item:CircleItem)
    func deleteItemFail(result:String, info: String)
}

class CircleManager{
    
    var circleItems:[CircleItem] = []
    
    var delegate:CircleManagerDelegate?
    
    var isRequesting:Bool = false
    
    // MARK:- 拉取消息
    
    // 拉取新的items
    func fetchNewCircleItems(){
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle", "method":"1", "square_item_id":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        
        if(!isRequesting){
            fetchCircleItems(parameters: parameters, removeAllItems: true, api: NetworkManager.SQUARE_FETCH_API)
        }else{
            print("重复请求")
        }
        
    }
    
    
    // 拉取旧的items
    func fetchOldCircleItems(){
        let lastItem = circleItems.last
        let square_item_id = lastItem?.circle_id
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle", "method":"2", "square_item_id":square_item_id!, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        if(!isRequesting){
            fetchCircleItems(parameters: parameters, removeAllItems: false, api: NetworkManager.SQUARE_FETCH_API)
        }else{
            print("重复请求")
        }
    }
    
    // 具体的网络请求
    private func fetchCircleItems(parameters:Parameters, removeAllItems:Bool, api:String){
        
        isRequesting = true
        
        Alamofire.request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        
                        let info = json["info"]
                        let items = info["item"].array!
                        var isThereItems:Bool = false
                        
                        if(removeAllItems){
                            self.circleItems.removeAll()
                        }
                        
                        for item in items{
                            isThereItems = true
                            
                            let circle_id = Int(item["circle_id"].string!)!
                            let user_id = Int(item["user_id"].string!)!
                            let user_nickname = item["user_nickname"].string!
                            let user_avatar = Int(item["user_avatar"].string!)!
                            let type = Int(item["type"].string!)!
                            let content = item["content"].string!
                            let create_date = item["create_date"].string!
                            let comment_count = Int(item["comment_count"].string!)!
                            let like_count = Int(item["like_count"].string!)!
                            let picture_count = Int(item["picture_count"].string!)!
                            
                            let circleItem = CircleItem(circle_id: circle_id, user_id:user_id, user_nickname:user_nickname, user_avatar:user_avatar,  type: type, content: content, create_date: create_date, comment_count: comment_count, like_count: like_count, picture_count: picture_count)
                            self.circleItems.append(circleItem)
                        }
                        
                        let like_str = info["like"].string!
                        let liked_id_array:[String] = like_str.components(separatedBy: "@")
                        for liked_id in liked_id_array{
                            if(!liked_id.equals(str: "")){
                                for item in self.circleItems{
                                    if item.circle_id == Int(liked_id) {
                                        item.isLiked = true
                                    }
                                }
                            }
                        }

                        
                        if(isThereItems){
                            self.delegate?.CircleFetchSuccess(result: "1", info: "成功c拉取到所有items")
                        }else{
                            self.delegate?.CircleFetchFail(result: "0", info: "没有更多的了")
                        }
    
                    }else{
                        self.delegate?.CircleFetchFail(result: "0", info: "response里result = 0")
                    }
                    
                }else{
                    self.delegate?.CircleFetchFail(result: "0", info: "解析json失败")
                }
            case .failure:
                self.delegate?.CircleFetchFail(result: "0", info: "response failure")
            }
            
            // 请求停止
            self.isRequesting = false
        }
    }
    
    // MARK:- 互动操作 点赞 评论 疑惑 更多（举报）
    
    // like
    func likeItem(item: CircleItem, isToCancel:Bool){
        if(isToCancel){
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle", "square_item_id":String(item.circle_id), "judge_type":"1", "is_to_cancel":"1", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_JUDGE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        if(json["result"].string!.equals(str: "1")){
                            self.delegate?.likeItemSuccess(item: item, isToCancel: isToCancel)
                        }else{
                            self.delegate?.likeItemFail(result: "0", info: json["info"].string!, isToCancel: isToCancel)
                        }
                    }
                case .failure:
                    self.delegate?.likeItemFail(result: "0", info: "response fail", isToCancel: isToCancel)
                }
            }
        }else{
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle", "square_item_id":String(item.circle_id), "judge_type":"1", "is_to_cancel":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_JUDGE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        if(json["result"].string!.equals(str: "1")){
                            self.delegate?.likeItemSuccess(item: item, isToCancel: isToCancel)
                        }else{
                            self.delegate?.likeItemFail(result: "0", info: json["info"].string!, isToCancel: isToCancel)
                        }
                    }
                case .failure:
                    self.delegate?.likeItemFail(result: "0", info: "response fail", isToCancel: isToCancel)
                }
            }
        }
    }
    
    
    
    
    //report
    func reportItem(item: CircleItem, content:String){
        
        let reportManger = ReportManager.manager
        reportManger.addReportedCircle(circle_id: item.circle_id)
        
        
        let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "reported_id":String(item.circle_id), "type":"circle", "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        Alamofire.request(NetworkManager.SQUARE_REPORT_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        self.delegate?.reportItemSuccess(item: item)
                    }else{
                        self.delegate?.reportItemFail(result: "0", info: json["info"].string!)
                    }
                }
            case .failure:
                self.delegate?.reportItemFail(result: "0", info: "response fail")
            }
        }
        
    }
    
    // delete
    func deleteItem(item: CircleItem){
        
        let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle","delete_type":"1", "correspond_id":String(item.circle_id), "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        Alamofire.request(NetworkManager.SQUARE_DELETE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        self.delegate?.deleteItemSuccess(item: item)
                    }else{
                        self.delegate?.deleteItemFail(result: "0", info: json["info"].string!)
                    }
                }
            case .failure:
                self.delegate?.deleteItemFail(result: "0", info: "response fail")
            }
        }
        
    }
    
    func managerDeleteItem(item: CircleItem, content: String){
            
    //        let reportManger = ReportManager.manager
    //        reportManger.addReportedBroadcast(broadcast_id: item.broadcast_id)
            
            
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "reported_id":String(item.circle_id), "type":"circle", "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            
            Alamofire.request(NetworkManager.SQUARE_MANAGER_DELETE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        if(json["result"].string!.equals(str: "1")){
                            self.delegate?.managerDeleteItemSuccess(item: item)
                        }else{
                            self.delegate?.managerDeleteItemFail(result: "0", info: json["info"].string!)
                        }
                    }
                case .failure:
                    self.delegate?.managerDeleteItemFail(result: "0", info: "response fail")
                }
            }
            
        }
    
    func removeItem(item: CircleItem){
        
        var index = 0
        
        for i in circleItems{
            if(i.circle_id == item.circle_id){
                circleItems.remove(at: index)
                break
            }
            index += 1
        }
    }
    
    func checkItems(){
        //举报的内容要move掉
        
        let reportManager = ReportManager.manager
        
        let reported_items = reportManager.getReportedCircle()
        let reported_users = reportManager.getReportedUser()
        
        
        for item in circleItems{
            
            for reported_item in reported_items{
                if(item.circle_id == reported_item.circle_id){
                    removeItem(item: item)
                }
            }
            
            for reported_user in reported_users{
                if(item.user_id == reported_user.user_id){
                    removeItem(item: item)
                }
            }
            
        }
        
    }
    
}


// MARK:- 我的动态
extension CircleManager{
    // 拉取新的items
    func fetchMyNewCircleItems(){
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle", "method":"1", "square_item_id":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        
        if(!isRequesting){
            fetchCircleItems(parameters: parameters, removeAllItems: true, api: NetworkManager.DISCOVER_MYPOST_FETCH_MY_POST)
        }else{
            print("重复请求")
        }
        
    }
    
    
    // 拉取旧的items
    func fetchMyOldCircleItems(){
        let lastItem = circleItems.last
        let square_item_id = lastItem?.circle_id
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"circle", "method":"2", "square_item_id":square_item_id!, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        if(!isRequesting){
            fetchCircleItems(parameters: parameters, removeAllItems: false, api:NetworkManager.DISCOVER_MYPOST_FETCH_MY_POST)
        }else{
            print("重复请求")
        }
    }
    
    
}
