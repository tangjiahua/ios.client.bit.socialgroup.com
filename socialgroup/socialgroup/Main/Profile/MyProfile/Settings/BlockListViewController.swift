//
//  BlockListViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit



class BlockListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var blockUsers:[ReportedUserModel] = []
    
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
        self.navigationItem.title = "黑名单"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        
        
        let reportManager = ReportManager()
        blockUsers = reportManager.getReportedUser()
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        cell.selectionStyle = .none
        
        let avatarImageView = UIImageView(frame: CGRect(x: padding, y: smallPadding, width: avatarHeight, height: avatarHeight))
        let avatarUrlStr:String = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + userDefaults.string(forKey: "socialgroup_id")! + "/profile/avatar/thumbnail/" + String(blockUsers[indexPath.row].user_id) + "@" + String(blockUsers[indexPath.row].avatar) + ".jpg"
        avatarImageView.sd_setImage(with: URL(string: avatarUrlStr), placeholderImage: UIImage(named: "placeholder"), options:[ .allowInvalidSSLCertificates], context: nil)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarHeight / 2
        avatarImageView.layer.masksToBounds = true
        cell.addSubview(avatarImageView)
        
        let nicknameLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + smallPadding, y: smallPadding + smallPadding, width: UIDevice.SCREEN_WIDTH - padding - avatarHeight - padding*2, height: nicknameHeight))
        nicknameLabel.text = blockUsers[indexPath.row].nickname
        nicknameLabel.font = .systemFont(ofSize: nicknameHeight)
        nicknameLabel.textColor = .label
        nicknameLabel.textAlignment = .left
        nicknameLabel.numberOfLines = 1
        cell.addSubview(nicknameLabel)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msgAlert = UIAlertController(title: "提示", message: "是否将该用户从黑名单中移除，移除后您将会重新看到该用户发布的内容", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            // 确定举报
            let manager = ReportManager()
            manager.removeReportedUser(user_id: self.blockUsers[indexPath.row].user_id)
            self.showTempAlert(info: "移除黑名单成功")
            self.blockUsers.remove(at: indexPath.row)
            self.tableView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        msgAlert.addAction(ok)
        msgAlert.addAction(cancel)
        self.present(msgAlert, animated: true, completion: nil)
    }
}
