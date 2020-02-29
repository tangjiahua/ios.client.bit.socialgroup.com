//
//  SquareReplyManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol SquareReplyManagerDelegate:NSObjectProtocol {
    func fetchSquareReplySuccess()
    func fetchSquareReplyFail()
    
    func pushReplySuccess()
    func pushReplyFail()
}

class SquareReplyManager{
    
    var delegate: SquareReplyManagerDelegate?
    
    var squareCommentItem:SquareCommentItem!
    
    var squareReplyItems:[SquareReplyItem] = []
    
    var isRequesting:Bool = false
    
    func initSquareReplyManger(squareCommentItem:SquareCommentItem){
        
        self.squareCommentItem = squareCommentItem
        
    }
    
    func fetchSquareReplyItems(){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": squareCommentItem.square_item_type, "square_item_id": squareCommentItem.square_item_id, "comment_id":squareCommentItem.comment_id , "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_FETCH_DETAIL_REPLY, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            let info = json["info"]
                            let items = info["reply"].array!
                            
                            self.squareReplyItems.removeAll()
                            
                            for item in items{
                                let reply_id = item["reply_id"].string!
                                let reply_from_user_id = item["reply_from_user_id"].string!
                                let nickname = item["nickname"].string!
                                let avatar = item["avatar"].string!
                                let reply_to_user_id = item["reply_to_user_id"].string!
                                let reply_to_user_nickname = item["reply_to_user_nickname"].string!
                                let content = item["content"].string!
                                let create_date = item["create_date"].string!
                                let replyItem = SquareReplyItem(square_item_type: self.squareCommentItem.square_item_type,square_item_id: self.squareCommentItem.square_item_id, comment_id: self.squareCommentItem.comment_id, reply_id: reply_id, reply_from_user_id: reply_from_user_id, nickname: nickname, avatar: avatar, reply_to_user_id: reply_to_user_id, reply_to_user_nickname: reply_to_user_nickname, content: content, create_date: create_date)
                                self.squareReplyItems.append(replyItem)
                            }
                            self.delegate?.fetchSquareReplySuccess()
                            
                        }else{
                            self.delegate?.fetchSquareReplyFail()
                        }
                    }
                case .failure:
                    self.delegate?.fetchSquareReplyFail()
                }
            }
        }else{
            print("重复请求")
        }
    }
    
    
    func pushReplyToComment(content:String){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": squareCommentItem.square_item_type, "square_item_id": squareCommentItem.square_item_id, "comment_id": squareCommentItem.comment_id,"reply_to_user_nickname":squareCommentItem.user_nickname,"reply_to_user_id":squareCommentItem.user_id, "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_REPLY_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            self.delegate?.pushReplySuccess()
                            
                        }else{
                            self.delegate?.pushReplyFail()
                        }
                    }
                case .failure:
                    self.delegate?.pushReplyFail()
                }
                
                
            }
        }
    }
    
    func pushReplyToReply(content:String, replyItem:SquareReplyItem){
        if(!isRequesting){
            isRequesting = true
            let parameters:[String:String] = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "square_item_type": squareCommentItem.square_item_type, "square_item_id": squareCommentItem.square_item_id, "comment_id": squareCommentItem.comment_id, "reply_to_user_nickname":replyItem.nickname,"reply_to_user_id":replyItem.reply_from_user_id, "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
            Alamofire.request(NetworkManager.SQUARE_REPLY_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                self.isRequesting = false
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            self.delegate?.pushReplySuccess()
                            
                        }else{
                            self.delegate?.pushReplyFail()
                        }
                    }
                case .failure:
                    self.delegate?.pushReplyFail()
                }
                
                
            }
        }
    }
    
}
