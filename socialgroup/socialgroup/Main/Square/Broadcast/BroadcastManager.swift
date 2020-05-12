//
//  SquareManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/22.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit


protocol BroadcastManagerDelegate:NSObjectProtocol {
    func BroadcastFetchSuccess(result:String, info:String)
    func BroadcastFetchFail(result:String, info:String)
    
    func likeItemSuccess(item:BroadcastItem, isToCancel:Bool)
    func likeItemFail(result:String, info: String, isToCancel:Bool)
    
    func dislikeItemSuccess(item:BroadcastItem, isToCancel:Bool)
    func dislikeItemFail(result:String, info: String, isToCancel:Bool)
    
    func reportItemSuccess(item:BroadcastItem)
    func reportItemFail(result:String, info: String)
    
    func deleteItemSuccess(item:BroadcastItem)
    func deleteItemFail(result:String, info: String)
}


class BroadcastManager {
    
    var broadcastItems:[BroadcastItem] = []
    
    var delegate:BroadcastManagerDelegate?
    
    var isRequesting:Bool = false
    
    // MARK:- 拉取消息
    
    // 拉取新的items
    func fetchNewBroadcastItems(){
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "method":"1", "square_item_id":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        
        if(!isRequesting){
            fetchBroadcastItems(parameters: parameters, removeAllItems: true, api: NetworkManager.SQUARE_FETCH_API)
        }else{
            print("重复请求")
        }
        
    }
    
    
    // 拉取旧的items
    func fetchOldBroadcastItems(){
        let lastItem = broadcastItems.last
        let square_item_id = lastItem?.broadcast_id
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "method":"2", "square_item_id":square_item_id!, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        if(!isRequesting){
            fetchBroadcastItems(parameters: parameters, removeAllItems: false, api: NetworkManager.SQUARE_FETCH_API)
        }else{
            print("重复请求")
        }
    }
    
    // 具体的网络请求
    private func fetchBroadcastItems(parameters:Parameters, removeAllItems:Bool, api:String){
        
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
                            self.broadcastItems.removeAll()
                        }
                        
                        for item in items{
                            isThereItems = true
                            
                            let broadcast_id = Int(item["broadcast_id"].string!)!
                            let type = Int(item["type"].string!)!
                            let title = item["title"].string!
                            let content = item["content"].string!
                            let create_date = item["create_date"].string!
                            let comment_count = Int(item["comment_count"].string!)!
                            let like_count = Int(item["like_count"].string!)!
                            let dislike_count = Int(item["dislike_count"].string!)!
                            let picture_count = Int(item["picture_count"].string!)!
                            
                            let broadcastItem = BroadcastItem(broadcast_id: broadcast_id, type: type, title: title, content: content, create_date: create_date, comment_count: comment_count, like_count: like_count, dislike_count: dislike_count, picture_count: picture_count)
                            self.broadcastItems.append(broadcastItem)
                        }
                        
                        let like_str = info["like"].string!
                        let liked_id_array:[String] = like_str.components(separatedBy: "@")
                        for liked_id in liked_id_array{
                            if(!liked_id.equals(str: "")){
                                for item in self.broadcastItems{
                                    if item.broadcast_id == Int(liked_id) {
                                        item.isLiked = true
                                    }
                                }
                            }
                        }

                        
                        let dislike_str = info["dislike"].string!
                        let disliked_id_array:[String] = dislike_str.components(separatedBy: "@")
                        for disliked_id in disliked_id_array{
                            if(!disliked_id.equals(str: "")){
                                for item in self.broadcastItems{
                                    if item.broadcast_id == Int(disliked_id) {
                                        item.isDisliked = true
                                    }
                                }
                            }
                        }
                        
                        if(isThereItems){
                            self.delegate?.BroadcastFetchSuccess(result: "1", info: "成功c拉取到所有items")
                        }else{
                            self.delegate?.BroadcastFetchFail(result: "0", info: "没有更多的了")
                        }
    
                    }else{
                        self.delegate?.BroadcastFetchFail(result: "0", info: "response里result = 0")
                    }
                    
                }else{
                    self.delegate?.BroadcastFetchFail(result: "0", info: "解析json失败")
                }
            case .failure:
                self.delegate?.BroadcastFetchFail(result: "0", info: "response failure")
            }
            
            // 请求停止
            self.isRequesting = false
        }
    }
    
    
    // MARK:- 互动操作 点赞 评论 疑惑 更多（举报）
    
    // like
    func likeItem(item: BroadcastItem, isToCancel:Bool){
        if(isToCancel){
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "square_item_id":String(item.broadcast_id), "judge_type":"1", "is_to_cancel":"1", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
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
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "square_item_id":String(item.broadcast_id), "judge_type":"1", "is_to_cancel":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
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
    
//    // comment
//    func commentItem(item:BroadcastItem){
//
//    }
    
    // dislike
    func dislikeItem(item:BroadcastItem, isToCancel:Bool){
        if(isToCancel){
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "square_item_id":String(item.broadcast_id), "judge_type":"2", "is_to_cancel":"1", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_JUDGE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        if(json["result"].string!.equals(str: "1")){
                            self.delegate?.dislikeItemSuccess(item: item, isToCancel: isToCancel)
                        }else{
                            self.delegate?.dislikeItemFail(result: "0", info: json["info"].string!, isToCancel: isToCancel)
                        }
                    }
                case .failure:
                    self.delegate?.dislikeItemFail(result: "0", info: "response fail", isToCancel: isToCancel)
                }
            }
        }else{
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "square_item_id":String(item.broadcast_id), "judge_type":"2", "is_to_cancel":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_JUDGE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        if(json["result"].string!.equals(str: "1")){
                            self.delegate?.dislikeItemSuccess(item: item, isToCancel: isToCancel)
                        }else{
                            self.delegate?.dislikeItemFail(result: "0", info: json["info"].string!, isToCancel: isToCancel)
                        }
                    }
                case .failure:
                    self.delegate?.dislikeItemFail(result: "0", info: "response fail", isToCancel: isToCancel)
                }
            }
        }
    }
    
    //report
    func reportItem(item: BroadcastItem){
        
        let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "square_item_id":String(item.broadcast_id), "judge_type":"3", "is_to_cancel":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        Alamofire.request(NetworkManager.SQUARE_JUDGE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    func deleteItem(item: BroadcastItem){
        
        let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast","delete_type":"1", "correspond_id":String(item.broadcast_id), "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
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
    
    
}

// MARK:- 我的Broadcast
extension BroadcastManager{
    func fetchMyNewBroadcastItems(){
//        {
//        “socialgroup_id”:1,    //1代表北理社群
//        “square_item_type”:“broadcast”,    //可以填broadcast或者circle
//        “method”:1,        //1代表拉取新的item，即以item的id为27为分界线拉取更新的数据；
//        “square_item_id”:27    //分界id
//        “user_id”:xx
//        “password”:xx
//        }
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "method":"1", "square_item_id":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        
        if(!isRequesting){
            fetchBroadcastItems(parameters: parameters, removeAllItems: true, api: NetworkManager.DISCOVER_MYPOST_FETCH_MY_POST)
        }else{
            print("重复请求")
        }
        
    }
    
    // 拉取旧的items
    func fetchMyOldBroadcastItems(){
        let lastItem = broadcastItems.last
        let square_item_id = lastItem?.broadcast_id
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":"broadcast", "method":"2", "square_item_id":square_item_id!, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        if(!isRequesting){
            fetchBroadcastItems(parameters: parameters, removeAllItems: false, api: NetworkManager.DISCOVER_MYPOST_FETCH_MY_POST)
        }else{
            print("重复请求")
        }
    }
}
