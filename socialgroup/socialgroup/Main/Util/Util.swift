//
//  Util.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/11.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit

class Util {
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
    
    static func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {

        let statusLabelText: NSString = labelStr as NSString

        let size = CGSize(width: width, height: 900)

        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)

        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any] , context: nil).size

        return strSize.height

    }
    
    
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
