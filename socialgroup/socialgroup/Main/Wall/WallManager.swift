//
//  WallManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/3/1.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol WallManagerDelegate:NSObjectProtocol {
    func fetchNewWallSuccess()
    func fetchNewWallFail()
    
    func fetchOldWallSuccess()
    func fetchOldWallFail()
}


class WallManager{
    
    var posterModels:[PosterModel] = []
    
    var delegate:WallManagerDelegate?
    
    func fetchNewWall(){
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "method":"1", "notification_id":"0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        Alamofire.request(NetworkManager.WALL_FETCH_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        let posterJson = json["info"]
                        // 清理models
                        self.posterModels.removeAll()
                        
                        
                        // 添加posters
                        if let posters = posterJson["poster"].array{
                            for poster in posters{
                                let noti_id = poster["notification_id"].string!
                                let user_id = poster["user_id"].string!
                                let user_nickname = poster["user_nickname"].string!
                                let user_avatar = poster["user_avatar"].string!
                                let type = poster["type"].string!
                                let create_date = poster["create_date"].string!
                                let brief = poster["brief"].string!
                                let welcome = poster["welcome"].string!
                                let hold_date = poster["hold_date"].string!
                                let hold_location = poster["hold_location"].string!
                                let holder = poster["holder"].string!
                                let detail = poster["detail"].string!
                                let link = poster["link"].string!
                                let posterModel = PosterModel(notification_id: noti_id, user_id: user_id, user_nickname: user_nickname, user_avatar: user_avatar, type: type, create_date: create_date, brief: brief, welcome: welcome, holddate: hold_date, holdlocation: hold_location, holder: holder, detail: detail, link: link)
                                self.posterModels.append(posterModel)
                            }
                        }
                        
                        // 添加其他的notifications
                        
                        self.delegate?.fetchNewWallSuccess()
                        break
                    }
                }
                self.delegate?.fetchNewWallFail()
            case .failure:
                self.delegate?.fetchNewWallFail()
            }
        }
        
    }
    
    func fetchOldWall(){
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "method":"2", "notification_id":posterModels.last?.notification_id ?? "0", "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        Alamofire.request(NetworkManager.WALL_FETCH_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        let posterJson = json["info"]
                        // 添加posters
                        if let posters = posterJson["poster"].array{
                            for poster in posters{
                                let noti_id = poster["notification_id"].string!
                                let user_id = poster["user_id"].string!
                                let user_nickname = poster["user_nickname"].string!
                                let user_avatar = poster["user_avatar"].string!
                                let type = poster["type"].string!
                                let create_date = poster["create_date"].string!
                                let brief = poster["brief"].string!
                                let welcome = poster["welcome"].string!
                                let hold_date = poster["hold_date"].string!
                                let hold_location = poster["hold_location"].string!
                                let holder = poster["holder"].string!
                                let detail = poster["detail"].string!
                                let link = poster["link"].string!
                                let posterModel = PosterModel(notification_id: noti_id, user_id: user_id, user_nickname: user_nickname, user_avatar: user_avatar, type: type, create_date: create_date, brief: brief, welcome: welcome, holddate: hold_date, holdlocation: hold_location, holder: holder, detail: detail, link: link)
                                self.posterModels.append(posterModel)
                            }
                        }
                        
                        // 添加其他的notifications
                        
                        self.delegate?.fetchOldWallSuccess()
                        break
                    }
                }
                self.delegate?.fetchOldWallFail()
            case .failure:
                self.delegate?.fetchOldWallFail()
            }
        }
        
    }
    
}
