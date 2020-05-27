//
//  OtherProfileManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/3/1.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol OtherProfileManagerDelegate:NSObjectProtocol {
    func stickSuccess()
    func stickFail()
    
    func reportUserSuccess(item:ProfileModel)
    func reportUserFail(result:String, info: String)
    
}

class OtherProfileManager{
    
    weak var delegate:OtherProfileManagerDelegate?
    
    func stick(model:ProfileModel){
        
        let parameters:[String:String] = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "stick_to_user_id":model.userid, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        Alamofire.request(NetworkManager.PROFILE_STICK_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        self.delegate?.stickSuccess()
                        break
                    }
                }
                self.delegate?.stickFail()
            case .failure:
                self.delegate?.stickFail()
            }
        }
    }
    
    //report
    func reportUser(item: ProfileModel, content: String){
        
        let reportManger = ReportManager.manager
//        reportManger.addReportedBroadcast(broadcast_id: item.broadcast_id)
//        var userid = Int(item.userid)
        reportManger.addReportedUser(user_id: Int(item.userid!)!, avatar: Int(item.avatar!)!, nickname: item.nickname)
        
        let parameters:Parameters = ["socialgroup_id": UserDefaultsManager.getSocialGroupId(), "reported_id": item.userid!, "type":"user", "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        Alamofire.request(NetworkManager.SQUARE_REPORT_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        self.delegate?.reportUserSuccess(item: item)
                    }else{
                        self.delegate?.reportUserFail(result: "0", info: json["info"].string!)
                    }
                }
            case .failure:
                self.delegate?.reportUserFail(result: "0", info: "response fail")
            }
        }
        
    }
    
}
