//
//  NotificationPushManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

protocol NotificationPushManagerDelegate:NSObjectProtocol {
    func pushPosterSuccess()
    func pushPosterFail(info: String)
}

class NotificationPushManager{
    
    var delegate:NotificationPushManagerDelegate?
    
    var api:String?
    
    func pushPoster(posterPushModel: PosterPushModel){

      var dic = [String:String]()
      dic["socialgroup_id"] = UserDefaultsManager.getSocialGroupId()
      dic["brief"] = ""
      
        dic["welcome"] = posterPushModel.welcome
        dic["hold_date"] = posterPushModel.holddate
        dic["hold_location"] = posterPushModel.holdlocation
        dic["holder"] = posterPushModel.holder
        dic["detail"] = posterPushModel.detail
        dic["link"] = posterPushModel.link
        
        
      dic["user_id"] = UserDefaultsManager.getUserId()
      dic["password"] = UserDefaultsManager.getPassword()
      
       let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
      let strJson = String(data: data!, encoding: .utf8)!

      do{
          let jsonData = strJson.data(using: .utf8)!
          
          Alamofire.upload(multipartFormData: { (multipart) in
              multipart.append(jsonData, withName: "json")
              // photo
            let photo = UIImage(contentsOfFile: posterPushModel.posterImagePath)!
                  let data = photo.jpegData(compressionQuality: 0.5)!
                  multipart.append(data, withName: "poster",fileName: "posterfile",  mimeType: "image/*")
              
              
          }, to: api!,method: .post) { (encodingResult) in
              
              switch encodingResult{
              case .success(let upload, _, _):
                  upload.responseJSON { (response) in
                      if let responseData = response.result.value{
                          let json = JSON(responseData)
                          let resultString = json["result"].string
                          if(resultString!.equals(str: "1")){
                            self.delegate?.pushPosterSuccess()
                          }else{
                            self.delegate?.pushPosterFail(info: json["info"].string!)
                          }
                      }
                  }
              case .failure(let error):
                  print(error)
                  self.delegate?.pushPosterFail(info: "网络请求失败")
              }
              
              
          }
      }
      
      
  }
}
