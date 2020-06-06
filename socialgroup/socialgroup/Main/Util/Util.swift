//
//  Util.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/11.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Alamofire
import SwiftyJSON

protocol UtilDelegate:NSObjectProtocol{
    func versionNeedUpdate()
}


class Util {
    
    public let VERSION = 1.11
    
    var delegate:UtilDelegate?
    
    //只能为数字
    static func onlyInputNumbers(_ string: String) -> Bool{
        let regex = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES%@", regex)
        return predicate.evaluate(with: string)
    }
    
    //只能为字母和数字
    static func onlyInputLettersOrNumbers(_ string: String) -> Bool{
        let regex = "[a-zA-Z0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES%@", regex)
        return predicate.evaluate(with: string)
    }
    
    
    // 版本更新
    func checkVersion(){
        let parameters:Parameters = ["device_type":"ios"]
        Alamofire.request(NetworkManager.CHECK_VERSION_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let result = json["result"].string!
                    if(result.equals(str: "1")){
                        let version = json["info"].string!
                        let versionNew = Double(version)!
                        if(self.VERSION < versionNew){
                            self.delegate?.versionNeedUpdate()
                        }
                    }
                }
            case .failure:
                print("check version fail")
            }
            
            
        }
    }
    
    
    
}

extension String{
    func equals(str: String) -> Bool{
        return (self.compare(str).rawValue == 0)
    }
}

extension UIColor {
    
    func asImage(_ size: CGSize) -> UIImage? {
        
        var resultImage: UIImage? = nil
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            return resultImage
        }
        
        context.setFillColor(self.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}

extension UITabBarController{
    func hideTabbar(hidden: Bool) {
          UIView.animate(withDuration: 0.2) {
              if hidden {
                  var frame = self.tabBar.frame
                frame.origin.y = UIDevice.SCREEN_HEIGHT + 2
                  self.tabBar.frame = frame
              } else {
                  var frame = self.tabBar.frame
                frame.origin.y = UIDevice.SCREEN_HEIGHT - self.tabBar.frame.height
                  self.tabBar.frame = frame
              }
          }
      }
}

extension UIView{
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

