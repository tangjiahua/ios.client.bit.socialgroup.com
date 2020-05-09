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
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
        
        // pop Gesture
        let popGesture = self.navigationController!.interactivePopGestureRecognizer
        let popTarget = popGesture?.delegate
        let popView = popGesture!.view!
        popGesture?.isEnabled = false
        
        let popSelector = NSSelectorFromString("handleNavigationTransition:")
        let fullScreenPoGesture = UIPanGestureRecognizer(target: popTarget, action: popSelector)
        fullScreenPoGesture.delegate = self
        
        popView.addGestureRecognizer(fullScreenPoGesture)

        // Do any additional setup after loading the view.
    }
    
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
       return true
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "更改资料"
        case 1:
            cell.textLabel?.text = "关于"
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
            let aboutVC = AboutViewController()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
