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
                                let squareItem = SquareCommentItem(square_item_type: self.square_item_type, comment_id: comment_id, user_id: user_id, user_nickname: user_nickname, user_avatar: user_avatar, content: content, create_date: create_date, reply_count: reply_count)
                                self.squareCommentItems.append(squareItem)
                            }
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
    

}
