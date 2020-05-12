//
//  EditTextProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol EditTextProfileViewControllerDelegate:NSObjectProtocol {
    func updateProfileSuccess()
}


class EditTextProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, EditTextDetailViewControllerDelegate, MyProfileModelDelegate {
    
    var delegate: EditTextProfileViewControllerDelegate?
    
    var tableView:UITableView!
    var genderPickerView:UIPickerView!
    
    let smallPadding:CGFloat = 5
    let padding:CGFloat = 10
    let rightTextLablWidth:CGFloat = 150
    let toolBarHeight:CGFloat = 70
    let saveButtonHeight:CGFloat = 50
    
    var profileModel:ProfileModel!
    var toolBar:UIToolbar!
    
    let editList = [
        "昵称",
        "真实姓名",
        "性别",
        "年龄",
        "家乡",
        "年级",
        "感情状态",
        "专业",
        "公开介绍",
        "私密介绍"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let profileVC = self.navigationController?.viewControllers.first as! MyProfileViewController
        delegate = profileVC
        
        self.navigationItem.title = "更改个人资料"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        
        profileModel.myProfileModelDelegate = self
        if(profileModel.getMyProfileModelFromLocal()){
            print("获取本地资料成功")
        }
        
        
        let uploadButton = UIButton(frame: CGRect(x: padding, y: padding, width: UIDevice.SCREEN_WIDTH - padding*2, height: saveButtonHeight))
        uploadButton.backgroundColor = .systemBlue
        uploadButton.setTitle("保存资料", for: .normal)
        uploadButton.layer.cornerRadius = 5
        uploadButton.layer.masksToBounds = true
        uploadButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIDevice.SCREEN_HEIGHT - toolBarHeight - UIDevice.HEIGHT_OF_ADDITIONAL_FOOTER, width: UIDevice.SCREEN_WIDTH, height: toolBarHeight))
        
        toolBar.addSubview(uploadButton)
        view.addSubview(toolBar)
        
    }
    
    
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        

        cell.textLabel?.text = editList[indexPath.row]

        let rightTextLabel = UILabel(frame: CGRect(x: UIDevice.SCREEN_WIDTH - rightTextLablWidth - padding, y: 0, width: rightTextLablWidth, height: cell.bounds.height))
        rightTextLabel.textColor = .lightGray
        rightTextLabel.textAlignment = .right
        cell.addSubview(rightTextLabel)
        
        switch indexPath.row {
        case 0:
            rightTextLabel.text = profileModel.nickname
        case 1:
            rightTextLabel.text = profileModel.realname
        case 2:
            var genderSymbol = "♂"
            if(profileModel.gender.equals(str: "f")){
                genderSymbol = "♀"
            }
            rightTextLabel.text = genderSymbol
        case 3:
            rightTextLabel.text = profileModel.age
        case 4:
            rightTextLabel.text = profileModel.hometown
        case 5:
            rightTextLabel.text = profileModel.grade
        case 6:
            rightTextLabel.text = profileModel.relationshipStatus
        case 7:
            rightTextLabel.text = profileModel.major
        case 8:
            rightTextLabel.text = profileModel.publicIntroduce
        case 9:
            rightTextLabel.text = profileModel.privateIntroduce
            
        default:
            cell.textLabel?.text = "默认"
        }
        
        
        if(indexPath.row + 1 < editList.count){
            let footer = UIView(frame: CGRect(x: padding, y: cell.frame.maxY - 1, width: UIDevice.SCREEN_WIDTH - 2*padding, height: 1))
            footer.backgroundColor = .darkGray
            cell.addSubview(footer)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editDetailVC = EditTextDetailViewController()
        editDetailVC.delegate = self
        
        switch indexPath.row {
        case 0:
            editDetailVC.initTextField(title: "昵称", oldValue: profileModel.nickname, limit: 20)
        case 1:
            editDetailVC.initTextField(title: "真实姓名", oldValue: profileModel.realname, limit: 10)
        case 2:
            editDetailVC.initPickerView(title: "性别")
        case 3:
            editDetailVC.initTextField(title: "年龄", oldValue: profileModel.age, limit: 2)
        case 4:
            editDetailVC.initTextField(title: "家乡", oldValue: profileModel.hometown, limit: 20)
        case 5:
            editDetailVC.initTextField(title: "年级", oldValue: profileModel.grade, limit: 4)
        case 6:
            editDetailVC.initTextField(title: "感情状态", oldValue: profileModel.relationshipStatus, limit: 20)
        case 7:
            editDetailVC.initTextField(title: "专业", oldValue: profileModel.major, limit: 20)
        case 8:
            editDetailVC.initTextView(title: "公开介绍", oldValue: profileModel.publicIntroduce, limit: 800)
        case 9:
            editDetailVC.initTextView(title: "私密介绍", oldValue: profileModel.privateIntroduce, limit: 400)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let nc = UINavigationController(rootViewController: editDetailVC)
        nc.modalPresentationStyle = .fullScreen
        self.present(nc, animated: true, completion: nil)
        
        
        
        
    }
    
    
    // MARK:- EditTextDetailViewControllerDelegate
    func changeInTextView(title: String, info: String) {
        if(title.equals(str: "公开介绍")){
            print(title)
            profileModel.publicIntroduce = info
        }else{
            print(title)
            profileModel.privateIntroduce = info
        }
        
        tableView.reloadData()
    }
    
    func changeInTextField(title: String, info: String) {
        switch title {
        case "昵称":
            profileModel.nickname = info
        case "真实姓名":
            profileModel.realname = info
        case "年龄":
            profileModel.age = info
        case "家乡":
            profileModel.hometown = info
        case "年级":
            profileModel.grade = info
        case "感情状态":
            profileModel.relationshipStatus = info
        case "专业":
            profileModel.major = info
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    func changeInPickerView(title: String, info: String) {
        if(title.equals(str: "性别")){
            if info.equals(str: "男") {
                profileModel.gender = "m"
            }else{
                profileModel.gender = "f"
            }
        }
        tableView.reloadData()
    }
    
    @objc func saveButtonTapped(){
        self.showLoading(text: "正在更改个人资料", isSupportClick: false)
        profileModel.setMyTextProfileModelToServer()
        
    }
    
    //MARK:- MyProfileModelDelegate
    func setMyTextProfileToServerSuccess() {
        self.hideHUD()
        self.showTempAlert(info: "更改个人资料成功")
        profileModel.setMyProfileModelToLocal()
        profileModel.getMyProfileModelFromServer()
        
        delegate?.updateProfileSuccess()
        
    }
    
    func setMyTextProfileToServerFail() {
        self.hideHUD()
        self.showTempAlert(info: "更改个人资料失败")
    }
    
    func getMyProfileServerSuccess() {
        
    }
    
    func getMyProfileServerFail(info: String) {
        
    }
    
    func setMyAvatarToServerSuccess() {
        
    }
    
    func setMyAvatarToServerFail() {
        
    }
    
    func setMyBackgroundToServerSuccess() {
        
    }
    
    func setMyBackgroundToServerFail() {
        
    }
    
    func setMyAddWallPhotoToServerSuccess() {
        
    }
    
    func setMyAddWallPhotoToServerFail() {
        
    }
    
    func setMyDeleteWallPhotoToServerSuccess() {
        
    }
    
    func setMyDeleteWallPhotoToServerFail() {
        
    }
}
