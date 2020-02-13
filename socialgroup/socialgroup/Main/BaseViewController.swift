//
//  BaseViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/13.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    public func isNetworking() -> Bool{
        if(!NetworkManager.isNetworking()){
            //无网络
            let alert = UIAlertController(title: "无网络", message: "无法连接到服务器", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    

}
