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

class Util {
    
    
    
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
                frame.origin.y = UIDevice.SCREEN_HEIGHT
                  self.tabBar.frame = frame
              } else {
                  var frame = self.tabBar.frame
                frame.origin.y = UIDevice.SCREEN_HEIGHT - self.tabBar.frame.height
                  self.tabBar.frame = frame
              }
          }
      }
}

