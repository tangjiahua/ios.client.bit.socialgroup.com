//
//  EditTextProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class EditTextProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    
    let smallPadding:CGFloat = 5
    let padding:CGFloat = 10
    let rightTextLablWidth:CGFloat = 150
    
    var profileModel:ProfileModel!
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

        self.navigationItem.title = "更改个人资料"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        
        profileModel = ProfileModel()
        if(profileModel.getMyProfileModelFromLocal()){
            print("获取本地资料成功")
        }
        
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
        
        cell.selectionStyle = .none
        
        let footer = UIView(frame: CGRect(x: padding, y: cell.frame.maxY - 1, width: UIDevice.SCREEN_WIDTH - 2*padding, height: 1))
        footer.backgroundColor = .darkGray
        cell.addSubview(footer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            let editProfileVC = EditProfileViewController()
//            self.navigationController?.pushViewController(editProfileVC, animated: true)
//        case 1:
//            let aboutVC = AboutViewController()
//            self.navigationController?.pushViewController(aboutVC, animated: true)
//        default:
//            break
//        }
    }

}
