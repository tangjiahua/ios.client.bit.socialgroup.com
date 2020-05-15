//
//  PushMessageManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/15.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol PushMessageManagerDelegate:NSObjectProtocol {
    func fetchFromServerSuccess()   //成功拉取消息，保存到数据库，返回条数可以用了
    func fetchFromServerFail()
    
}


struct PushMessageModel{
    var push_message_id:Int
    var type:Int
    var content:String
    var create_date:String
}



class PushMessageManager{
    
    static let manager = PushMessageManager()
    

    private var sqliteManager = SQLiteManager.manager
    
    var delegate:PushMessageManagerDelegate?
    
    private var pushMessageModels:[PushMessageModel] = []
    
    
    private var newestPushMessageId = UserDefaultsManager.getNewestPushMessageId(){
        didSet{
            UserDefaultsManager.setNewestPushMessageId(id: newestPushMessageId)
        }
    }
    
    
    public func getNewPushMessageCount() -> Int{
        return UserDefaultsManager.getNewPushMessageCount()
    }
    
    public func resetNewPushMessageCount(){
        UserDefaultsManager.setNewPushMessageCount(count: 0)
    }
    
    
    public func getPushMessageModels() -> [PushMessageModel]{
        pushMessageModels.removeAll()
        
        let jsons = sqliteManager.searchPushMessage(limit: nil, offset: nil)
        
        for json in jsons{
            let model = PushMessageModel(push_message_id: json["push_message_id"].int!, type: json["type"].int!,  content: json["content"].string!, create_date: json["create_date"].string!)
            pushMessageModels.append(model)
            
        }
        return pushMessageModels
    }
    
    
    
    
    
    //MARK:- 拉取消息使用fetch()
    
    public func fetchFromServer(){
        if(newestPushMessageId == 0){
            getNewestPushMessageId()
        }else{
            getNewestPushMessage()
        }
    }
    
    //拉取最新的推送
    private func getNewestPushMessage(){
        let parameters:Parameters = ["newest_push_message_id":String(newestPushMessageId),
                                     "socialgroup_id":UserDefaultsManager.getSocialGroupId(),
                                     "user_id":UserDefaultsManager.getUserId(),
                                     "password":UserDefaultsManager.getPassword()]
        Alamofire.request(NetworkManager.DISCOVER_FETCH_PUSH_MESSAGE, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        let info = json["info"]
                        let push_message_id_new = info["push_message_id_new"].string!
                        self.newestPushMessageId = Int(push_message_id_new)!
                        
                        let push_messages = info["push_message"].array!
                        self.pushMessageModels.removeAll()
                        for push_message in push_messages{
                            
                            let push_message_id = push_message["push_message_id"].string!
                            let create_date = push_message["create_date"].string!
                            let type = push_message["type"].string!
                            let content = push_message["content"]
                            
                            if(type.equals(str: "3")){
                                // 代表是戳一戳消息
                                let whoStickMeUserId = content["user_id"].string!
                                let content = "{\"user_id\":\(whoStickMeUserId)}"
                                let item = PushMessageModel(push_message_id: Int(push_message_id)!, type: Int(type)!, content: content, create_date: create_date)
                                self.pushMessageModels.append(item)
                                
                            }else if(type.equals(str: "1") || type.equals(str: "2")){
                                let square_item_type = content["square_item_type"].string!
                                let square_item_id = content["square_item_id"].string!
                                let content = "{\"square_item_type\":\(square_item_type),\"square_item_id\":\(square_item_id)}"
                                let item = PushMessageModel(push_message_id: Int(push_message_id)!, type: Int(type)!, content: content, create_date: create_date)
                                self.pushMessageModels.append(item)
                            }
                            
                            
                        }
                        
                        let old_count = UserDefaultsManager.getNewPushMessageCount()
                        UserDefaultsManager.setNewPushMessageCount(count: old_count + push_messages.count)
                        
                        
                        self.addNewPushMessageToLocal()
                        
                        self.delegate?.fetchFromServerSuccess()
                        break
                    }
                }
                self.delegate?.fetchFromServerFail()
            case .failure:
                self.delegate?.fetchFromServerFail()
            }
        }
    }
    
    private func addNewPushMessageToLocal(){
        for model in pushMessageModels{
            
            let json:JSON = ["push_message_id":model.push_message_id, "type":model.type, "content":model.content, "create_date":model.create_date]
            sqliteManager.insertPushMessageTable(item: json)
        }
        
    }
    
    // 拉取最新的推送id
    private func getNewestPushMessageId(){
        let parameters:Parameters = ["newest_push_message_id":"0",
                                     "socialgroup_id":UserDefaultsManager.getSocialGroupId(),
                                     "user_id":UserDefaultsManager.getUserId(),
                                     "password":UserDefaultsManager.getPassword()]
        Alamofire.request(NetworkManager.DISCOVER_FETCH_PUSH_MESSAGE, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        let info = json["info"]
                        let push_message_id_new = info["push_message_id_new"].string!
                        self.newestPushMessageId = Int(push_message_id_new)!
                        
                        self.delegate?.fetchFromServerSuccess()
                        break
                    }
                }
                self.delegate?.fetchFromServerFail()
            case .failure:
                self.delegate?.fetchFromServerFail()
            }
        }
        
    }
    
}
