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
    
    
    
    override func moreButtonTapped(){
       let pushTappedSheet = UIAlertController.init(title: "更多", message: nil, preferredStyle: .actionSheet)
       self.present(pushTappedSheet, animated: true, completion: nil)
        
        pushTappedSheet.addAction(.init(title: "举报并将该用户加入黑名单", style: .default, handler:{(action: UIAlertAction) in
            
            var inputText:UITextField = UITextField()
            let msgAlert = UIAlertController(title: "举报", message: "描述您的举报理由，能够帮助我们快速排查违规行为", preferredStyle: .alert)
            let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
                // 确定举报
                let manager = OtherProfileManager()
                manager.delegate = self
                let content = inputText.text ?? ""
                manager.reportUser(item: self.profileModel, content: content)
                
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                print("cancel")
            }
            msgAlert.addAction(ok)
            msgAlert.addAction(cancel)
            msgAlert.addTextField { (textField) in
                inputText = textField
                inputText.placeholder = "输入理由"
            }
            self.present(msgAlert, animated: true, completion: nil)
            
        }))
        pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
        
        
        
   }
    
    
    override func stickButtonTapped() {
        
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
        
    
    override func avatarTappedGesture() {
        let imageBrowserManager = ImageBrowserManager()
//        let tableview = self.superview as! UITableView
//        let controller = tableview.dataSource as! UIViewController
//        controller.tabBarController?.hideTabbar(hidden: true)
        let avatarUrlStr:String = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.socialgroup_id + "/profile/avatar/" + profileModel.userid + "@" + profileModel.avatar + ".jpg"
        imageBrowserManager.imageBrowserManagerWithUrlStr(imageUrls:[avatarUrlStr], originalImageViews: [self.avatarView], controller: self, titles: [])
        imageBrowserManager.selectPage = 0
        imageBrowserManager.showImageBrowser()
    }
    
    override func backgroundTappedGesture() {
        let imageBrowserManager = ImageBrowserManager()
        //        let tableview = self.superview as! UITableView
        //        let controller = tableview.dataSource as! UIViewController
        //        controller.tabBarController?.hideTabbar(hidden: true)
        let backgroundUrlStr:String = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.socialgroup_id + "/profile/background/" + profileModel.userid + "@" + profileModel.background + ".jpg"
        imageBrowserManager.imageBrowserManagerWithUrlStr(imageUrls:[backgroundUrlStr], originalImageViews: [self.backgroundView], controller: self, titles: [])
        imageBrowserManager.selectPage = 0
        imageBrowserManager.showImageBrowser()
    }
        

}

extension OtherProfileViewController{
    // MARK:- OtherProfileModelDelegate
    func getOtherProfileServerSuccess() {
        print("get my profile server success")
        
        if(profileModel.userid.equals(str: UserDefaultsManager.getUserId())){
            moreButton.isHidden = true
        }
        
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
        let count = Int(profileModel.stickCount)! + 1
        super.stickCountLabel.text = String(count)
        profileModel.stickCount = String(count)
        super.stickCountLabel.setNeedsDisplay()
    }
    
    func stickFail() {
        print("stick fail")
        self.showTempAlertWithOneSecond(info: "戳一戳失败")
    }
    
    func reportUserSuccess(item: ProfileModel) {
//        self.show(text: <#T##String?#>)
        let msgAlert = UIAlertController(title: "提示", message: "举报成功，我们将尽快审核您的举报内容，您将不会看到该用户发表的内容", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            // 确定举报
            
        }
        msgAlert.addAction(ok)
        self.present(msgAlert, animated: true, completion: nil)
        
        
//        self.showTempAlert(info: "举报成功，我们将尽快审核您的举报内容，您将不会看到该用户发表的内容")
    }
    
    func reportUserFail(result: String, info: String) {
        self.showTempAlert(info: "举报上传至服务器失败，您将不会看到该用户发表的内容")
        
        
        let msgAlert = UIAlertController(title: "提示", message: "举报上传至服务器失败，您将不会看到该用户发表的内容", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            // 确定举报
            
        }
        msgAlert.addAction(ok)
        self.present(msgAlert, animated: true, completion: nil)

    }
    
   
    
    
}
