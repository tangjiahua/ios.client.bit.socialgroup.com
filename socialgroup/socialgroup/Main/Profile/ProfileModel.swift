//
//  ProfileModel.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

@objc protocol MyProfileModelDelegate: NSObjectProtocol {
    func getMyProfileServerSuccess()
    func getMyProfileServerFail(info: String)
    func setMyAvatarToServerSuccess()
    func setMyAvatarToServerFail()
    func setMyBackgroundToServerSuccess()
    func setMyBackgroundToServerFail()
    func setMyTextProfileToServerSuccess()
    func setMyTextProfileToServerFail()
    func setMyAddWallPhotoToServerSuccess()
    func setMyAddWallPhotoToServerFail()
    func setMyDeleteWallPhotoToServerSuccess()
    func setMyDeleteWallPhotoToServerFail()
}

class ProfileModel{
    
    var avatar:String!
    var background:String!
    var stickCount:String!
    var nickname:String!
    var realname:String!
    var gender:String!
    var age:String!
    var wallPhotosCount:String!
    var grade:String!
    var hometown:String!
    var major:String!
    var relationshipStatus:String!
    var publicIntroduce:String!
    var privateIntroduce:String!
    var role:String!

    var isMyProfile:Bool = false
    var isPrivateAbleToSee:Bool = false
    let userDefaults = UserDefaults.standard
    var myProfileModelDelegate:MyProfileModelDelegate?
    
    
    
    func setBasicModel(){
        avatar = "placeholder"
        background = "placeholder"
        stickCount = "0"
        nickname = ""
        realname = ""
        gender = ""
        age = ""
        wallPhotosCount = "0"
        grade = ""
        hometown = ""
        major = ""
        relationshipStatus = ""
        publicIntroduce = ""
        privateIntroduce = ""
        role = ""
        
    }
    
    
    
    //MARK:- other's profile model functions
    
    
    
    
    
    //MARK:- my profile model functions
    
    //从model到服务器
    func setMyAvatarOrBackgroundToServer(fileLocation:String, method:String){
        // method 1代表换头像
        // method 2代表换背景
        
        var fieldName:String
        if(method.equals(str: "1")){
            fieldName = "new_avatar"
        }else{
            fieldName = "new_background"
        }
        var dic = [String:String]()
        dic["socialgroup_id"] = userDefaults.string(forKey: "socialgroup_id")
        dic["method"] = method
        dic["user_id"] = userDefaults.string(forKey: "user_id")
        dic["password"] = userDefaults.string(forKey: "password")
        var jsonData:Data
        do{
            jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(jsonData, withName: "json")
                multipartFormData.append(URL(fileURLWithPath: fileLocation), withName: fieldName)
            }, to: NetworkManager.PROFILE_UPDATE_API, method: .post, headers: nil) { (encodingResult) in
                switch encodingResult{
                case .success(let upload, _, _):
                    upload.responseJSON { (response) in
                        if let responseData = response.result.value{
                            let json = JSON(responseData)
                            let resultString = json["result"].string
                            if(resultString!.equals(str: "1")){
                                if(method.equals(str: "1")){
                                    let newAvatarCount = String(Int(self.avatar)! + 1)
                                    self.avatar = newAvatarCount
                                    self.setMyProfileModelToLocal()
                                    self.myProfileModelDelegate?.setMyAvatarToServerSuccess()
                                }else{
                                    let newBackgroundCount = String(Int(self.background)! + 1)
                                    self.background = newBackgroundCount
                                    self.setMyProfileModelToLocal()
                                    self.myProfileModelDelegate?.setMyBackgroundToServerSuccess()
                                }
                            }else{
                                self.myProfileModelDelegate?.setMyBackgroundToServerFail()
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.myProfileModelDelegate?.setMyAvatarToServerFail()
                }
            }
        }catch(let error){
            print(error)
        }
    }
    
    
    
    func setMyTextProfileModelToServer(){
        
        let parameters:Parameters = [
            "socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!,
            "method":"3",
            "nickname":nickname!,
            "realname":realname!,
            "gender":gender!,
            "age":age!,
            "public_introduce":publicIntroduce!,
            "private_introduce":privateIntroduce!,
            "grade":grade!,
            "hometown":hometown!,
            "major":major!,
            "relationship_status":relationshipStatus!,
            "user_id":userDefaults.string(forKey: "user_id")!,
            "password":userDefaults.string(forKey: "password")!
        ]
        Alamofire.request(NetworkManager.PROFILE_UPDATE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let info = json["result"].string!
                    if(info.equals(str: "1")){
                        //更改资料成功
                        self.setMyProfileModelToLocal()
                        self.myProfileModelDelegate?.setMyTextProfileToServerSuccess()
                        
                    }else{
                        self.myProfileModelDelegate?.setMyTextProfileToServerFail()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func setMyAddWallPhotoToServer(fileLocations: [String]){
        
        var dic = [String:String]()
        dic["socialgroup_id"] = userDefaults.string(forKey: "socialgroup_id")
        dic["method"] = "4"
        dic["user_id"] = userDefaults.string(forKey: "user_id")
        dic["password"] = userDefaults.string(forKey: "password")
        dic["new_wall_picture_count"] = String(fileLocations.count)
        var jsonData:Data
        
        do{
            jsonData = try JSONSerialization.data(withJSONObject: dic, options: [])
            Alamofire.upload(multipartFormData: { (multipart) in
                multipart.append(jsonData, withName: "json")
                for i in fileLocations{
                    multipart.append(URL(fileURLWithPath: i), withName: "picture")
                }
                
            }, to: NetworkManager.PROFILE_UPDATE_API,method: .post) { (encodingResult) in
                switch encodingResult{
                case .success(let upload, _, _):
                    upload.responseJSON { (response) in
                        if let responseData = response.result.value{
                            let json = JSON(responseData)
                            let resultString = json["result"].string
                            if(resultString!.equals(str: "1")){
                                let newWallPicCount = String(Int(self.wallPhotosCount)! + fileLocations.count)
                                self.wallPhotosCount = newWallPicCount
                                self.setMyProfileModelToLocal()
                                self.myProfileModelDelegate?.setMyAddWallPhotoToServerSuccess()
                            }else{
                                self.myProfileModelDelegate?.setMyAddWallPhotoToServerFail()
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.myProfileModelDelegate?.setMyAddWallPhotoToServerFail()
                }
                
                
            }
            
            
        }catch(let error){
            print(error)
        }
    }
    
    
    
    func setMyDeleteWallPhotoToServer(delete: String){
        
        let parameters:Parameters = [
            "socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!,
            "method":"5",
            "delete":delete,
            "user_id":userDefaults.string(forKey: "user_id")!,
            "password":userDefaults.string(forKey: "password")!
        ]
        Alamofire.request(NetworkManager.PROFILE_UPDATE_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let info = json["result"].string!
                    if(info.equals(str: "1")){
                        //删除照片墙照片成功
                        let newWallPicCount = String(Int(self.wallPhotosCount)! - 1)
                        self.avatar = newWallPicCount
                        self.setMyProfileModelToLocal()
                        self.myProfileModelDelegate?.setMyDeleteWallPhotoToServerSuccess()
                    }else{
                        self.myProfileModelDelegate?.setMyDeleteWallPhotoToServerFail()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    

    //从服务器到model
    func getMyProfileModelFromServer(){
        let parameters:Parameters = ["socialgroup_id":userDefaults.string(forKey: "socialgroup_id")!, "method":"2", "user_id":userDefaults.string(forKey: "user_id")!, "password":userDefaults.string(forKey: "password")!]
        Alamofire.request(NetworkManager.PROFILE_DETAIL_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    if(json["result"].string!.equals(str: "1")){
                        //拉取成功
                        let profile:JSON = json["info"]
                        self.nickname = profile["nickname"].string
                        self.realname = profile["realname"].string
                        self.gender = profile["gender"].string
                        self.age = profile["age"].string
                        self.avatar = profile["avatar"].string
                        self.background = profile["background"].string
                        self.stickCount = profile["stick_count"].string
                        self.wallPhotosCount = profile["wall_picture_count"].string
                        self.publicIntroduce = profile["public_introduce"].string
                        self.privateIntroduce = profile["private_introduce"].string
                        self.grade = profile["grade"].string
                        self.hometown = profile["hometown"].string
                        self.major = profile["major"].string
                        self.relationshipStatus = profile["relationship_status"].string
                        self.role = profile["role"].string
                        self.myProfileModelDelegate?.getMyProfileServerSuccess()
                        self.isPrivateAbleToSee = true
                    }else{
                        //拉取失败
                        self.myProfileModelDelegate?.getMyProfileServerFail(info: json["info"].string!)
                    }
                }
            case .failure(let error):
                print(error)
                self.myProfileModelDelegate?.getMyProfileServerFail(info: "response error")
            }
        }
        
    }
    
    //从本地获取到model
    public func getMyProfileModelFromLocal() -> Bool{
        if(userDefaults.bool(forKey: "isMyProfileExists")){
            avatar = userDefaults.string(forKey: "avatar")
            background = userDefaults.string(forKey: "background")
            stickCount = userDefaults.string(forKey: "stick_count")
            nickname = userDefaults.string(forKey: "nickname")
            realname = userDefaults.string(forKey: "realname")
            gender = userDefaults.string(forKey: "gender")
            age = userDefaults.string(forKey: "age")
            grade = userDefaults.string(forKey: "grade")
            hometown = userDefaults.string(forKey: "hometown")
            major = userDefaults.string(forKey: "major")
            relationshipStatus = userDefaults.string(forKey: "relationship_status")
            publicIntroduce = userDefaults.string(forKey: "public_introduce")
            privateIntroduce = userDefaults.string(forKey: "private_introduce")
            role = userDefaults.string(forKey: "role")
            isPrivateAbleToSee = true
            return true
        }
        return false
    }
    
    //将model保存在本地
    public func setMyProfileModelToLocal(){
        userDefaults.set(avatar, forKey: "avatar")
        userDefaults.set(background, forKey: "background")
        userDefaults.set(stickCount, forKey: "stick_count")
        userDefaults.set(nickname, forKey: "nickname")
        userDefaults.set(realname, forKey: "realname")
        userDefaults.set(gender, forKey: "gender")
        userDefaults.set(age, forKey: "age")
        userDefaults.set(hometown, forKey: "hometown")
        userDefaults.set(major, forKey: "major")
        userDefaults.set(grade, forKey: "grade")
        userDefaults.set(relationshipStatus, forKey: "relationship_status")
        userDefaults.set(publicIntroduce, forKey: "public_introduce")
        userDefaults.set(privateIntroduce, forKey: "private_introduce")
        userDefaults.set(role, forKey: "role")
        userDefaults.set(true, forKey: "isMyProfileExists")
    }
    
    
}
