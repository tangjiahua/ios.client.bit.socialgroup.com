//
//  MessageViewController.swift
//  Mask
//
//  Created by 汤佳桦 on 2019/10/5.
//  Copyright © 2019 Beijing Institute of Technology. All rights reserved.
//

import Foundation
import UIKit

class DiscoverViewController:BaseViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, PushMessageBadgeChangeProtocol, PosterPushViewControllerDelegate{
   
    
    
    
    
    var tableView:UITableView!
    
    var button:UIButton?
    
    let badgeWidth:CGFloat = 25
    let badgeX:CGFloat = 65
    var badgeY:CGFloat{
        return (cellHeight - 10 - badgeWidth)/2
    }
    
    let cellHeight:CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground
        self.navigationController!.navigationBar.barTintColor = UIColor.secondarySystemBackground
        self.title = "发现"
        
        
        
        // pop Gesture
        let popGesture = self.navigationController!.interactivePopGestureRecognizer
        let popTarget = popGesture?.delegate
        let popView = popGesture!.view!
        popGesture?.isEnabled = false
        
        let popSelector = NSSelectorFromString("handleNavigationTransition:")
        let fullScreenPoGesture = UIPanGestureRecognizer(target: popTarget, action: popSelector)
        fullScreenPoGesture.delegate = self
        
        popView.addGestureRecognizer(fullScreenPoGesture)
        
        setUpSubViews()
        
        
        // MainView的代理设置
        let mainVC = tabBarController as? MainController
        mainVC?.pushMessageBadgeChangeDelegate = self
    }
    
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController!.viewControllers.count > 1 {
            return true
        }
       return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        discoverMessageBadgeChange()
    }
    
    func discoverMessageBadgeChange() {
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    func setUpSubViews(){
        
        //tableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        view.addSubview(tableView)
    }
    
    
    //MARK: UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
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
            case 2:
                cell?.textLabel?.text = "我发布的广播"
            case 3:
                cell?.textLabel?.text = "我发布的动态"
            case 4:
                cell?.textLabel?.text = "消息"
                if let badgeValue = tabBarItem.badgeValue{
                    if(button != nil){
                        button?.setTitle(badgeValue, for: .normal)
                    }else{
                        button = UIButton(frame: CGRect(x: badgeX, y: badgeY, width: badgeWidth, height: badgeWidth))
                        button?.layer.cornerRadius = badgeWidth/2
                        button?.layer.masksToBounds = true
                        button!.backgroundColor = .red
                        button!.setTitle(badgeValue, for: .normal)
                        
                        cell?.addSubview(button!)
                    }
                    
                }
            case 5:
                cell?.textLabel?.text = "张贴海报"
            default:
                cell!.textLabel?.text = "Nothing"
            }
        }else{
            // 刷新消息的角标
            if(indexPath.row == 4){
                if let badgeValue = tabBarItem.badgeValue{
                    if(button != nil){
                        button?.setTitle(badgeValue, for: .normal)
                    }else{
                        button = UIButton(frame: CGRect(x: badgeX, y: badgeY, width: badgeWidth, height: badgeWidth))
                        button!.backgroundColor = .red
                        button!.setTitle(badgeValue, for: .normal)
                        button?.layer.cornerRadius = badgeWidth/2
                        button?.layer.masksToBounds = true
                        cell?.addSubview(button!)
                    }
                    
                }
            }
        }
        
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let socialNetsVC = SocialNetsViewController()
            socialNetsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(socialNetsVC, animated: true)
        case 1:
            showFindInputWindow()
        case 2:
            let myBroadcastVC = MyBroadcastViewController()
            myBroadcastVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myBroadcastVC, animated: true)
        case 3:
            let myCircleVC = MyCircleViewController()
            myCircleVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myCircleVC, animated: true)
        case 4:
            let pushMessageVC = PushMessageViewController()
            pushMessageVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(pushMessageVC, animated: true)
            
            // 消除tabbar角标
            PushMessageManager.manager.resetNewPushMessageCount()
            tabBarItem.badgeValue = nil
            //消除tablecell角标
            if(button != nil){
                button?.removeFromSuperview()
                button = nil
                tableView.reloadData()
            }
            //消除应用图标
            UIApplication.shared.applicationIconBadgeNumber = 0
        case 5:
            let alert = UIAlertController(title: "注意", message: "为了公告墙的质量，当您在此处发布海拔之后，海报不会立刻被张贴在公告墙上，请联系开发者获取张贴海报权限或者临时张贴活动海报，感谢您的支持！", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let okAction = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
                let pushPosterVC = PosterPushViewController()
                pushPosterVC.modalPresentationStyle = .fullScreen
                pushPosterVC.setUpViews()
                pushPosterVC.delegate = self
                pushPosterVC.push_api = NetworkManager.WALL_PUSH_USER_API
                self.present(pushPosterVC, animated: true, completion: nil)
            }
            alert.addAction(okAction)
            
            
            
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func posterPushSuccess() {
        self.showTempAlert(info: "感谢您！发布成功，请联系开发者让海报展示在公告墙上")
        
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

