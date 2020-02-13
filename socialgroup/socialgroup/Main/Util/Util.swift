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
