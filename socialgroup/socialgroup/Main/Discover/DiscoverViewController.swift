//
//  MessageViewController.swift
//  Mask
//
//  Created by 汤佳桦 on 2019/10/5.
//  Copyright © 2019 Beijing Institute of Technology. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewController:BaseViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        self.navigationController!.navigationBar.barTintColor = UIColor.secondarySystemBackground
        self.title = "发现"
        
        
        setUpSubViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpSubViews(){
        
        //tableView
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
    }
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "reuseCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if(cell == nil){
            cell = DiscoverTableViewCell(style: .default, reuseIdentifier: cellid)
            switch indexPath.row {
            case 0:
                cell!.textLabel!.text = "社交网络"
            case 1:
                cell!.textLabel?.text = "寻人启事"
            default:
                cell!.textLabel?.text = "Nothing"
            }
            
            
            return cell!
        }
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let socialNetsVC = SocialNetsViewController()
            socialNetsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(socialNetsVC, animated: true)
        case 1:
            showFindInputWindow()
            
        default:
            return
        }
    }
    
    private func showFindInputWindow(){
        var inputText:UITextField = UITextField()
        let msgAlert = UIAlertController(title: "搜索", message: "输入对方真实姓名", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            
            let findUserVC = FindUserViewController()
            findUserVC.setFindBy(realName: inputText.text ?? "")
            findUserVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(findUserVC, animated: true)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        msgAlert.addAction(ok)
        msgAlert.addAction(cancel)
        msgAlert.addTextField { (textField) in
            inputText = textField
            inputText.placeholder = "输入真实姓名"
        }
        self.present(msgAlert, animated: true, completion: nil)
        

    }
}

