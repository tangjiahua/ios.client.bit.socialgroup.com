//
//  TableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseProfileViewController, MyProfileModelDelegate {
    
    var wallEditButton:UIButton!
    var publicIntroduceEditButton:UIButton!
    var privateIntroduceEditButton:UIButton!
    
    let buttonHeight:CGFloat = 20
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.profileModel.myProfileModelDelegate = self
        initMyProfileView()
    }
    
    private func initMyProfileView(){
        
        if(super.profileModel.getMyProfileModelFromLocal()){
            print("get my profile local success")
            super.refreshProfileView()
        }else{
            super.profileModel.getMyProfileModelFromServer()
        }
        
        
        
    }
    
    
    
    //MARK:- MyProfileViewButton functions
    override func moreButtonTapped(){
        let settingVC = SettingViewController()
        self.navigationController.push

    }
    
    override func stickButtonTapped(){
        print("stick button tapped")

    }
    
    override func avatarTappedGesture() {
        print("avatar tapped")
    }
    
    override func backgroundTappedGesture() {
        print("bg tapped")
    }
    
    @objc func textProfileTapped(){
        print("hello")

    }
    
    @objc func wallEditButtonTapped(){
        print("hello")
    }
    
    @objc func publicIntroduceEditButtonTapped(){
        print("hello")

    }
    
    @objc func privateIntroduceEditButtonTapped(){
        print("hello")

    }
    
    //MARK:- MyProfileModelDelegate
    
    func getMyProfileServerSuccess() {
        print("get my profile server success")
        super.refreshProfileView()
        super.profileModel.setMyProfileModelToLocal()
    }
    
    func getMyProfileServerFail(info: String) {
        let alert = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setMyAvatarToServerSuccess() {
        print("setMyAvatarToServerSuccess")
    }
    
    func setMyAvatarToServerFail() {
        print("hello")
    }
    
    func setMyBackgroundToServerSuccess() {
                print("hello")

    }
    
    func setMyBackgroundToServerFail() {
                print("hello")

    }
    
    func setMyTextProfileToServerSuccess() {
                print("hello")

    }
    
    func setMyTextProfileToServerFail() {
                print("hello")

    }
    
    func setMyAddWallPhotoToServerSuccess() {
                print("hello")

    }
    
    func setMyAddWallPhotoToServerFail() {
                print("hello")

    }
    
    func setMyDeleteWallPhotoToServerSuccess() {
                print("hello")

    }
    
    func setMyDeleteWallPhotoToServerFail() {
                print("hello")

    }

}
