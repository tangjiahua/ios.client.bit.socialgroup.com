//
//  NetworkManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/13.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//


import Foundation
import Alamofire

class NetworkManager{
    static let SERVER_API_URL:String = "https://www.bitsocialgroup.com/api/"
    static let SERVER_URL:String = "https://www.bitsocialgroup.com"
    static let PROFILE_DETAIL_API:String = "https://www.bitsocialgroup.com/api/profile/detail"
    static let PROFILE_UPDATE_API:String = "https://www.bitsocialgroup.com/api/profile/update"
    static let PROFILE_STICK_LIST_API:String = "https://www.bitsocialgroup.com/api/profile/stick_list"
    static let SQUARE_FETCH_API:String = "https://www.bitsocialgroup.com/api/square/fetch"
    static let SQUARE_JUDGE_API:String = "https://www.bitsocialgroup.com/api/square/judge"
    static let SQUARE_PUSH_API:String = "https://www.bitsocialgroup.com/api/square/push"
    
    
    
    
    
    static let manager:NetworkReachabilityManager! = NetworkReachabilityManager(host: "https://www.bitsocialgroup.com")
    
    static let SERVER_RESOURCE_URL:String = "https://www.bitsocialgroup.com/resource/"
    
    
    
    static func isNetworking() -> Bool{
        return manager.isReachable
    }
    
    // 监听，如果网络变化了，会出现不同
     static func listenToNetworking(){
        manager.listener = { status in
             print("网络状态: \(status)")
             if status == .reachable(.ethernetOrWiFi) { //WIFI
                 print("wifi")
             } else if status == .reachable(.wwan) { // 蜂窝网络
                 print("4G")
             } else if status == .notReachable { // 无网络
                 print("无网络")
             } else { // 其他
                 
             }
         }
        manager.startListening()//开始监听网络
        }
}
