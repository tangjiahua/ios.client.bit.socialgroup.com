//
//  OtherProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/23.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class OtherProfileViewController: BaseProfileViewController, OtherProfileModelDelegate {
    
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
        if(scrollView.contentOffset.y < -150){
            backButtonTapped()
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
}
