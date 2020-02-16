//
//  MainTabBarController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class MainController: UITabBarController, UITabBarControllerDelegate {
    
    let squareVC = SquareViewController()
    let wallVC = WallViewController()
    let discoverVC = DiscoverViewController()
    let profileVC = MyProfileViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileVC.profileModel = ProfileModel()
        profileVC.profileModel.setBasicModel()
        profileVC.profileModel.isMyProfile = true
        initTabBarItems()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.windows.first?.rootViewController = self

    }
    

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(item.title == "我"){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /*
     初始化TabBar的Items
     */
    private func initTabBarItems(){
        squareVC.tabBarItem.title = "广场"
        squareVC.tabBarItem.image = UIImage(named: "squareTabBarIcon")

        wallVC.tabBarItem.title = "公告墙"
        wallVC.tabBarItem.image = UIImage(named: "wallTabBarIcon")
        
        discoverVC.tabBarItem.title = "发现"
        discoverVC.tabBarItem.image = UIImage(named: "discoverTabBarIcon")
        
        profileVC.tabBarItem.title = "我"
        profileVC.tabBarItem.image = UIImage(named: "profileTabBarIcon")
        
        viewControllers = [UINavigationController(rootViewController: squareVC),
                           UINavigationController(rootViewController: wallVC),
                           UINavigationController(rootViewController: discoverVC),
                           UINavigationController(rootViewController: profileVC)]
    }
    
    

    

}


