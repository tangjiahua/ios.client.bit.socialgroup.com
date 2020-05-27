//
//  SettingViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/16.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    
    var tableView:UITableView!
    
    let smallPadding:CGFloat = 5
    let padding:CGFloat = 10
    
    var profileModel:ProfileModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        
       
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "更改资料"
        case 1:
            cell.textLabel?.text = "账号设置"
        case 2:
            cell.textLabel?.text = "介绍"
        case 3:
            cell.textLabel?.text = "联系我们"
        case 4:
            cell.textLabel?.text = "使用条款"
        case 5:
            cell.textLabel?.text = "隐私政策"
        case 6:
            cell.textLabel?.text = "退出账号"
        case 7:
            cell.textLabel?.text = "黑名单"
        default:
            cell.textLabel?.text = "默认"
        }
        
        
        let footer = UIView(frame: CGRect(x: padding, y: cell.frame.maxY - 1, width: UIDevice.SCREEN_WIDTH - 2*padding, height: 1))
        footer.backgroundColor = .darkGray
        
        cell.addSubview(footer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let editProfileVC = EditProfileViewController()
            editProfileVC.profileModel = profileModel
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        case 1:
            let editAccountVC = EditAccountViewController()
            self.navigationController?.pushViewController(editAccountVC, animated: true)
        case 2:
            let aboutVC = WebPageViewController()
            aboutVC.initFAQ()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        case 3:
            let contactVC = WebPageViewController()
            contactVC.initContact()
            self.navigationController?.pushViewController(contactVC, animated: true)
        case 4:
            let termsVC = WebPageViewController()
            termsVC.initTerms()
            self.navigationController?.pushViewController(termsVC, animated: true)
        case 5:
            let privacyVC = WebPageViewController()
            privacyVC.initPrivacy()
            self.navigationController?.pushViewController(privacyVC, animated: true)
        case 6:
            showLogOutWindow()
        case 7:
            let blockListVC = BlockListViewController()
            self.navigationController?.pushViewController(blockListVC, animated: true)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     弹出退出登录确认窗口
     */
    private func showLogOutWindow(){
        let msgAlert = UIAlertController(title: "退出", message: "是否确定退出该账号？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.logOut()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        msgAlert.addAction(ok)
        msgAlert.addAction(cancel)
        self.present(msgAlert, animated: true, completion: nil)
    }
    
    /*
     确定退出登录
     */
    private func logOut(){
        UserDefaultsManager.deleteUserInfo()
        PushMessageManager.manager.disconnect()
//        PushMessageManager.manager.dropPushMessageDatabase()
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
}
