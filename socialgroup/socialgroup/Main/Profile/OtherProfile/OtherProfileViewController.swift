//
//  OtherProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/23.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class OtherProfileViewController: BaseProfileViewController, OtherProfileModelDelegate, OtherProfileManagerDelegate {
    
    var backButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initBackButton()
        // Do any additional setup after loading the view.
        moreButton.isHidden = true
    }
    
    func getProfile(user_id:Int){
        let user_id_str = String(user_id)
        profileModel.getOtherProfileModelFromServer(another_user_id: user_id_str)
    }

    func initBackButton(){
        backButton = UIButton()
        backButton.setImage(UIImage(named: "down"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.frame = CGRect(x: padding, y: UIDevice.STATUS_BAR_HEIGHT + padding, width: moreButtonWidth, height: moreButtonWidth)
        backButton.backgroundColor = .none
        backButton.layer.shadowOpacity = 0.5
        backButton.layer.shadowColor = UIColor.black.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        backButton.layer.shadowRadius = 3
        headerView.addSubview(backButton)

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc func backButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        print(scrollView.contentOffset.y)
        if(scrollView.contentOffset.y < -125){
            backButtonTapped()
        }
    }
    
    override func stickButtonTapped() {
        
        if(profileModel.isPrivateAbleToSee){
            self.showTempAlertWithOneSecond(info: "您已经戳过TA了")
        }else{
            let alert = UIAlertController(title: "确定戳一戳TA吗", message: "对方会收到戳一戳通知，并且能够看到您的私密个人介绍，并且戳一戳不可撤回", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                let manager = OtherProfileManager()
                manager.delegate = self
                manager.stick(model:self.profileModel)
            })
            let noAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }

}

extension OtherProfileViewController{
    // MARK:- OtherProfileModelDelegate
    func getOtherProfileServerSuccess() {
        print("get my profile server success")
        super.refreshProfileView()
    }
    
    func getOtherProfileServerFail(info: String) {
        let alert = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - OtherProfileManagerDelegate
    
    func stickSuccess() {
        self.showTempAlertWithOneSecond(info: "戳一戳成功")
    }
    
    func stickFail() {
        print("stick fail")
        self.showTempAlertWithOneSecond(info: "戳一戳失败")
    }
    
}
