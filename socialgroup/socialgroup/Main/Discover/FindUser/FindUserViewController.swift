//
//  UserListViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/16.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SDWebImage

class FindUserViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UserListManagerDelegate {
    
    var findByRealName:String!
    
    var userListManager:UserListManager!
    var tableView:UITableView!
    
    let smallPadding:CGFloat = 5
    let padding:CGFloat = 10
    let cellHeight:CGFloat = 60
    let avatarHeight:CGFloat = 50
    let nicknameHeight:CGFloat = 20
    let realnameHeight:CGFloat = 15
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "寻人启事"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        
        
    }
    
    func setFindBy(info:String, method:String){
        
        if(method.equals(str: "1")){
            userListManager = UserListManager()
            userListManager.delegate = self
            userListManager.fetchFindUserListBy(info: info, method:"1")
        }else if(method.equals(str: "2")){
            userListManager = UserListManager()
            userListManager.delegate = self
            userListManager.fetchFindUserListBy(info: info, method:"2")
        }
        
        
    }
    
    
    //MARK:- tableview delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showOtherProfile(userId: Int(userListManager.model[indexPath.row].user_id)!)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListManager.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        cell.selectionStyle = .none
        
        let avatarImageView = UIImageView(frame: CGRect(x: padding, y: smallPadding, width: avatarHeight, height: avatarHeight))
        let avatarUrlStr:String = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + userDefaults.string(forKey: "socialgroup_id")! + "/profile/avatar/thumbnail/" + userListManager.model[indexPath.row].user_id + "@" + userListManager.model[indexPath.row].avatar + ".jpg"
        avatarImageView.sd_setImage(with: URL(string: avatarUrlStr), placeholderImage: UIImage(named: "placeholder"), options:[ .allowInvalidSSLCertificates], context: nil)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarHeight / 2
        avatarImageView.layer.masksToBounds = true
        cell.addSubview(avatarImageView)
        
        let nicknameLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + smallPadding, y: smallPadding + smallPadding, width: UIDevice.SCREEN_WIDTH - padding - avatarHeight - padding*2, height: nicknameHeight))
        nicknameLabel.text = userListManager.model[indexPath.row].nickname
        nicknameLabel.font = .systemFont(ofSize: nicknameHeight)
        nicknameLabel.textColor = .label
        nicknameLabel.textAlignment = .left
        nicknameLabel.numberOfLines = 1
        cell.addSubview(nicknameLabel)
        
        
        var genderSymbol = "♂"
        if(userListManager.model[indexPath.row].gender.equals(str: "f")){
            genderSymbol = "♀"
        }
        let realnameLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + smallPadding, y: nicknameLabel.frame.maxY + smallPadding, width: UIDevice.SCREEN_WIDTH - padding - avatarHeight - padding*2, height: realnameHeight))
        realnameLabel.text = "@" + userListManager.model[indexPath.row].realname + " · " + genderSymbol + " · " + userListManager.model[indexPath.row].age
        realnameLabel.font = .systemFont(ofSize: realnameHeight)
        realnameLabel.textAlignment = .left
        realnameLabel.textColor = .tertiaryLabel
        realnameLabel.numberOfLines = 1
        cell.addSubview(realnameLabel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    //MARK:-userListManager delegate
    
    func fetchStickToMeListSuccess(count:Int) {
        if(count == 0){
            self.showTempAlert(info: "😢没有查到任何人")
        }
        tableView.reloadData()
    }
    
    func fetchStickToMeListFail(info: String) {
        self.showTempAlert(info: "拉取查找结果失败！怎么可能！")
        self.navigationController?.popViewController(animated: true)
    }

}
