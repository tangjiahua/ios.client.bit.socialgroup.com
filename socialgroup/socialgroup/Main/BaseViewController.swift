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
    
    public func showTempAlert(info: String){
        let alertController = UIAlertController(title: info, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    public func showTempAlertWithOneSecond(info:String){
        let alertController = UIAlertController(title: info, message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    public func showOtherProfile(userId:Int){
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: userId)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
    }

}
