//
//  UIInformation.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit


extension UIDevice{
    
//    static let viewHeightWithoutTabNavOthersExceptAdditionalFooter:CGFloat = UIScreen.main.bounds.height - UIApplication.shared.windows.first!.windowScene!.statusBarManager!.statusBarFrame.height - UINavigationController().navigationBar.frame.height - UITabBarController().tabBar.frame.height
    
    


    static let HEIGHT_OF_ADDITIONAL_FOOTER:CGFloat = {
        if UIDevice.current.isiPhoneXorLater(){
            return 34.0
        }else{
            return 0
        }
    }()
    
    
    public func isiPhoneXorLater() ->Bool{
        let screenHieght = UIScreen.main.nativeBounds.size.height
        if screenHieght == 2436 || screenHieght == 1792 || screenHieght == 2688 || screenHieght == 1624{
            return true
        }
        return false
    }
    

    
}





