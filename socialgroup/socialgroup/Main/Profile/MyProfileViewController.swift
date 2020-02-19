//
//  TableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class MyProfileViewController: BaseProfileViewController, MyProfileModelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var wallEditButton:UIButton!
    var publicIntroduceEditButton:UIButton!
    var privateIntroduceEditButton:UIButton!
    
    let buttonHeight:CGFloat = 20
    var uploadMethod:Int = 1    //1代表头像，2代表背景
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.profileModel.myProfileModelDelegate = self
        initMyProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        refreshProfileView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(self.navigationController!.viewControllers.count <= 1){
            tabBarController?.hideTabbar(hidden: false)
        }
        
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
        settingVC.profileModel = super.profileModel
        
        
        if(self.navigationController?.viewControllers.count == 1){
            self.tabBarController?.hideTabbar(hidden: true)
        }
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    override func stickButtonTapped(){
        print("stick button tapped")
        let stickListVC = UserListViewController()
        self.navigationController?.pushViewController(stickListVC, animated: true)
        
    }
    
    override func avatarTappedGesture() {
        print("avatar tapped")
        uploadMethod = 1
        let avatarTappedSheet = UIAlertController.init(title: "选择上传头像的方式", message: nil, preferredStyle: .actionSheet)
        self.present(avatarTappedSheet, animated: true, completion: nil)
        avatarTappedSheet.addAction(.init(title: "从相册上传", style: .default, handler:{(action: UIAlertAction) in
            if(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                return
            }
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = true
            photoPicker.delegate = self
            photoPicker.modalPresentationStyle = .fullScreen
            self.present(photoPicker, animated: true, completion: nil)
        } ))
        avatarTappedSheet.addAction(.init(title: "取消", style: .cancel, handler:{(action: UIAlertAction) in
        } ))
    }
    
    override func backgroundTappedGesture() {
        print("bg tapped")
        uploadMethod = 2
        let avatarTappedSheet = UIAlertController.init(title: "选择上传背景的方式", message: nil, preferredStyle: .actionSheet)
        self.present(avatarTappedSheet, animated: true, completion: nil)
        avatarTappedSheet.addAction(.init(title: "从相册上传", style: .default, handler:{(action: UIAlertAction) in
            if(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                return
            }
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = true
            photoPicker.delegate = self
            photoPicker.modalPresentationStyle = .fullScreen
            self.present(photoPicker, animated: true, completion: nil)
        } ))
        avatarTappedSheet.addAction(.init(title: "取消", style: .cancel, handler:{(action: UIAlertAction) in
        } ))
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
        self.hideHUD()
        showTempAlert(info: "更改头像成功")
        refreshProfileView()
    }
    
    func setMyAvatarToServerFail() {
        print("setMyAvatarToServerFail")
        self.hideHUD()
        showTempAlert(info: "更改头像失败")
    }
    
    func setMyBackgroundToServerSuccess() {
        print("setMyAvatarToServerSuccess")
        self.hideHUD()
        showTempAlert(info: "更改背景成功")
        refreshProfileView()
        
    }
    
    func setMyBackgroundToServerFail() {
        print("setMyAvatarToServerFail")
        self.hideHUD()
        showTempAlert(info: "更改背景失败")

    }
    
    func setMyTextProfileToServerSuccess() {
        super.refreshProfileView()

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
    
    
    //MARK:- UIImagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.showLoading(text: "正在上传", isSupportClick: false)
        
        let mediaType = info[.mediaType] as! String
        let userDefault = UserDefaults.standard
        if(mediaType == "public.image"){
            var headimage = info[.editedImage] as! UIImage
            //进行图片压缩
            headimage = compressImageQuality(headimage, toByte: 300 * 1024)
            
            let data = headimage.jpegData(compressionQuality: 1)
            
            
            let userid = userDefault.integer(forKey: "user_id")
            let profilePath:String = NSHomeDirectory() + "/Library/Caches/"
            let filetmpPath = profilePath + String(userid) + "temp" + ".jpg"
            let fileManager = FileManager.default
            
            if(!fileManager.fileExists(atPath: filetmpPath)){
                fileManager.createFile(atPath: filetmpPath, contents: data, attributes: nil)
            }else{
                try! fileManager.removeItem(atPath: filetmpPath)
                fileManager.createFile(atPath: filetmpPath, contents: data, attributes: nil)
            }
            
            switch uploadMethod {
            case 1:
                super.profileModel.setMyAvatarOrBackgroundToServer(fileLocation: filetmpPath, method: "1")
                self.dismiss(animated: true, completion: nil)
            case 2:
                super.profileModel.setMyAvatarOrBackgroundToServer(fileLocation: filetmpPath, method: "2")
                self.dismiss(animated: true, completion: nil)
            default:
                print("上传方法不是0也不是1")
            }
        }
    }
    
    
    
    //MARK:-压缩图片
    func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression),
            data.count > maxLength else { return image }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return UIImage(data: data)!
    }

}
