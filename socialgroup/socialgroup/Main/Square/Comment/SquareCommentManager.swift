//
//  SquareCommentManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/27.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol SquareCommentManagerDelegate:NSObjectProtocol {
    func fetchSquareCommentItemsSuccess()
    func fetchSquareCommentItemsFail()
    
    func fetchSquareLikeItemsSuccess()
    func fetchSquareLikeItemsFail()
    
    func fetchSquareDislikeItemsSuccess()
    func fetchSquareDislikeItemsFail()
    
    func pushCommentSuccess()
    func pushCommentFail()
    
    func deleteMyCommentSuccess(item:SquareCommentItem)
    func deleteMyCommentFail(result:String, info: String)
    
    func reportCommentSuccess(item:SquareCommentItem)
    func reportCommentFail(result:String, info: String)
    
}

class SquareCommentManager{
    
    var delegate:SquareCommentManagerDelegate?
    
    var socialgroup_id:String!
    
    var square_item_type:String!
    
    var square_item_id:String!
    
    var squareCommentItems:[SquareCommentItem] = []
    
    var squareLikeItems:[SquareJudgeItem] = []
    
    var squareDislikeItems:[SquareJudgeItem] = []
    
    var isRequesting:Bool = false
    
    func initSquareCommentManager(square_item_type:String, square_item_id:String){
        self.square_item_type = square_item_type
        self.square_item_id = square_item_id
    }
    
    func fetchSquareLikeItems(){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": square_item_type, "square_item_id": square_item_id, "method": "like", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_FETCH_DETAIL_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            let items = json["info"].array!
                            
                            self.squareLikeItems.removeAll()
                            
                            for item in items{
                                let judge_type = "like"
                                let judge_id = item["judge_id"].string!
                                let user_id = item["user_id"].string!
                                let user_nickname = item["nickname"].string!
                                let user_avatar = item["avatar"].string!
                                let likeItem = SquareJudgeItem(judge_type: judge_type
                                    , judge_id: judge_id, user_id: user_id, user_nickname: user_nickname, user_avatar: user_avatar)
                                self.squareLikeItems.append(likeItem)
                            }
                            self.delegate?.fetchSquareLikeItemsSuccess()
                            
                        }else{
                            self.delegate?.fetchSquareLikeItemsFail()
                        }
                    }
                case .failure:
                    self.delegate?.fetchSquareLikeItemsFail()
                }
                
            }
        }
    }
    
    func fetchSquareDislikeItems(){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": square_item_type, "square_item_id": square_item_id, "method": "dislike", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_FETCH_DETAIL_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            let items = json["info"].array!
                            
                            self.squareDislikeItems.removeAll()
                            
                            for item in items{
                                let judge_type = "dislike"
                                let judge_id = item["judge_id"].string!
                                let user_id = item["user_id"].string!
                                let user_nickname = item["nickname"].string!
                                let user_avatar = item["avatar"].string!
                                let dislikeItem = SquareJudgeItem(judge_type: judge_type
                                    , judge_id: judge_id, user_id: user_id, user_nickname: user_nickname, user_avatar: user_avatar)
                                self.squareDislikeItems.append(dislikeItem)
                            }
                            self.delegate?.fetchSquareDislikeItemsSuccess()
                            
                        }else{
                            self.delegate?.fetchSquareDislikeItemsFail()
                        }
                    }
                case .failure:
                    self.delegate?.fetchSquareDislikeItemsFail()
                }
                
            }
        }
    }
    
    func fetchSquareCommentItems(){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": square_item_type, "square_item_id": square_item_id, "method": "comment", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_FETCH_DETAIL_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            let info = json["info"]
                            let items = info["comment"].array!
                            
                            self.squareCommentItems.removeAll()
                            
                            for item in items{
                                let comment_id = item["comment_id"].string!
                                let user_id = item["user_id"].string!
                                let user_nickname = item["user_nickname"].string!
                                let user_avatar = item["user_avatar"].string!
                                let content = item["content"].string!
                                let create_date = item["create_date"].string!
                                let reply_count = item["reply_count"].string!
                                let squareItem = SquareCommentItem(square_item_id:self.square_item_id, square_item_type: self.square_item_type, comment_id: comment_id, user_id: user_id, user_nickname: user_nickname, user_avatar: user_avatar, content: content, create_date: create_date, reply_count: reply_count)
                                self.squareCommentItems.append(squareItem)
                            }
                            
                            self.checkItems()
                            
                            
                            self.delegate?.fetchSquareCommentItemsSuccess()
                            
                        }else{
                            self.delegate?.fetchSquareCommentItemsFail()
                        }
                    }
                case .failure:
                    self.delegate?.fetchSquareCommentItemsFail()
                }
            }
        }else{
            print("重复请求")
        }
    }
    
    func pushComment(content: String){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": square_item_type, "square_item_id": square_item_id, "content": content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_COMMENT_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            self.delegate?.pushCommentSuccess()
                            
                        }else{
                            self.delegate?.pushCommentFail()
                        }
                    }
                case .failure:
                    self.delegate?.pushCommentFail()
                }
                
                
            }
        }
    }
    
    func deleteMyComment(item: SquareCommentItem){
        if(!isRequesting){
            isRequesting = true
            let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type":item.square_item_type!, "delete_type":"2", "correspond_id":item.comment_id!,  "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
               Alamofire.request(NetworkManager.SQUARE_DELETE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                    
                   case .success:
                       if let data = response.result.value{
                           let json = JSON(data)
                           if(json["result"].string!.equals(str: "1")){
                               self.removeItem(item: item)
                               self.delegate?.deleteMyCommentSuccess(item: item)
                           
                           }else{
                               self.delegate?.deleteMyCommentFail(result: "0", info: json["info"].string!)
                           }
                       }
                   case .failure:
                       self.delegate?.deleteMyCommentFail(result: "0", info: "response fail")
                   }
               }
        }
    }
    
    
    func reportComment(item: SquareCommentItem, content: String){
        let reportManger = ReportManager.manager
        reportManger.addReportedUser(user_id: Int(item.user_id!)!, avatar: Int(item.user_avatar!)!, nickname: item.user_nickname)
        
        
        let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "reported_id":item.user_id!, "type":"user", "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        Alamofire.request(NetworkManager.SQUARE_REPORT_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        self.delegate?.reportCommentSuccess(item: item)
                    }else{
                        self.delegate?.reportCommentFail(result: "0", info: json["info"].string!)
                    }
                }
            case .failure:
                self.delegate?.reportCommentFail(result: "0", info: "response fail")
            }
        }
    }
    
    
    
    
    func checkItems(){
        //举报的内容要move掉
        
        let reportManager = ReportManager.manager
        
        let reported_users = reportManager.getReportedUser()
        
        
        for item in squareCommentItems{
            
            
            for reported_user in reported_users{
                if(Int(item.user_id!)! == reported_user.user_id){
                    removeItem(item: item)
                }
            }
            
        }
        
    }
    
    
    func removeItem(item: SquareCommentItem){
        
        var index = 0
        
        for i in squareCommentItems{
            if(i.comment_id == item.comment_id){
                squareCommentItems.remove(at: index)
                break
            }
            index += 1
        }
    }
    
    

}
