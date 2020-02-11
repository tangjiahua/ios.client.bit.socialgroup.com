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
    
    static var SERVER_URL:String = "http://192.144.254.174:8080"

    static let STATUS_BAR_HEIGHT:CGFloat = UIApplication.shared.windows.first!.windowScene!.statusBarManager!.statusBarFrame.height

    static let NAVIGATION_BAR_HEIGHT: CGFloat = UINavigationController().navigationBar.frame.height

    static let TAB_BAR_HEIGHT = UITabBar().bounds.height

    static let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
    
    static let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
    
    static let TITLE_FONT:UIFont = UIFont.systemFont(ofSize: 15)//标题的大小
    
    static let TITLE_HEIGHT:CGFloat = 40.0//标题滚动视图的高度
    
    static let UNDERLINE_HEIGHT:CGFloat = 4.0//自定义滑动条的高度
    
    static let TITLE_COLOR_CHOSEN:UIColor = UIColor.label //标题选中的颜色

    static let BUTTON_STAR_TAG:Int = 2000


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



