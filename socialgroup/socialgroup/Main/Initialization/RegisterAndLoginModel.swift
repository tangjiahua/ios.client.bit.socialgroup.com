//
//  RegisterModel.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/12.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol RegisterModelDelegate: NSObjectProtocol {
    
    func receiveRegisterResponse(result:String, info:String)
}

protocol LoginModelDelegate:NSObjectProtocol {
    func receiveLoginFailResponse(result: String, info: String)
    func receiveLoginSuccessResponse(result: String, info: String)
}


class RegisterAndLoginModel {
    
    private var account:String!
    private var password:String!
    private var userId:String!
    
    private var api = NetworkManager.SERVER_API_URL + "register_or_login"
    
    weak var registerDelegate: RegisterModelDelegate?
    weak var loginDelegate: LoginModelDelegate?
    
    
    init(_ account: String, _ password: String) {
        self.account = account
        self.password = password
    }
    
    
    //MARK:- send request
    public func sendRegisterRequest() {
        let iphoneInfo = "iOS"
        let parameters:Parameters = ["method":"register","account":account!, "password":password!, "device_type":iphoneInfo ]
        Alamofire.request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    let info = json["info"].string!
                    self.registerDelegate?.receiveRegisterResponse(result: result, info: info)
                }
            case .failure(let error):
                print(error)
                self.registerDelegate?.receiveRegisterResponse(result: "0", info: "response failure")
            }
        }
    }
    
    public func sendLoginRequest(){
        let parameters:Parameters = ["method":"login","account":account!, "password":password!]
        Alamofire.request(api, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        let user_id = json["info"]["user_id"].string!
                        self.loginDelegate?.receiveLoginSuccessResponse(result: result, info: user_id)
                    }else{
                        let info = json["info"].string!
                        self.loginDelegate?.receiveLoginFailResponse(result: result, info: info)
                    }
                    
                }
            case .failure(let error):
                print(error)
                self.loginDelegate?.receiveLoginFailResponse(result: "0", info: "response failure")
            }
        }
    }
    
    //MARK:- update properties
    public func setUserId(_ userId: String){
        self.userId = userId
    }
}
