//
//  MainTabBarController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import AudioToolbox

protocol PushMessageBadgeChangeProtocol:NSObjectProtocol{
    func discoverMessageBadgeChange()
}

class MainController: UITabBarController, UITabBarControllerDelegate, PushMessageManagerDelegate {
    
    let squareVC = SquareScrollViewController()
    let wallVC = WallViewController()
    let discoverVC = DiscoverViewController()
    let profileVC = MyProfileViewController()

    var manager = PushMessageManager.manager
    var timer:Timer?
    var pushMessageBadgeChangeDelegate:PushMessageBadgeChangeProtocol?
    
    var isFirstlyLaunch:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //square
        
        
        
        //profile
        profileVC.profileModel = ProfileModel()
        profileVC.profileModel.setBasicModel()
        profileVC.profileModel.isMyProfile = true
        initTabBarItems()
        
        
        //timer
        fetchFromServerSuccess()
        fetchFromServer()
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(fetchFromServer), userInfo: nil, repeats: true)
        manager.delegate = self
        
        //application badge
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound], completionHandler: { (success, error) in
          print("授权" + (success ? "成功" : "失败"))
        })
        
    }
    
    private func updateTimer(count:Int) {
        
        if let old_count_str = self.tabBar.items?[2].badgeValue{
            let old_count = Int(old_count_str)!
            if(count > old_count){
                let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                //振动
                AudioServicesPlaySystemSound(soundID)
                
                
                
                self.tabBar.items?[2].badgeValue = count > 0 ? "\(count)" : nil
                
                pushMessageBadgeChangeDelegate?.discoverMessageBadgeChange()

                UIApplication.shared.applicationIconBadgeNumber = count
            }
        }else{
            
            if(!isFirstlyLaunch){
                let soundID = SystemSoundID(kSystemSoundID_Vibrate)
                //振动
                AudioServicesPlaySystemSound(soundID)
                
            }
            isFirstlyLaunch = false
            self.tabBar.items?[2].badgeValue = count > 0 ? "\(count)" : nil
            
            pushMessageBadgeChangeDelegate?.discoverMessageBadgeChange()

            UIApplication.shared.applicationIconBadgeNumber = count
        }
        
        

    }
    
    func fetchFromServerSuccess() {
        print("fetch success---------------------------------------------------------------------------")
        let count = manager.getNewPushMessageCount()
        if(count != 0){
            updateTimer(count: count)
        }
        
    }
    
    func fetchFromServerFail() {
        
    }
    
    @objc func fetchFromServer(){
        manager.fetchFromServer()
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
//        pushMessageBadgeChangeDelegate = discoverVC
        
        
        profileVC.tabBarItem.title = "我"
        profileVC.tabBarItem.image = UIImage(named: "profileTabBarIcon")
        
        viewControllers = [UINavigationController(rootViewController: squareVC),
                           UINavigationController(rootViewController: wallVC),
                           UINavigationController(rootViewController: discoverVC),
                           UINavigationController(rootViewController: profileVC)]
    }
    
    

    

}


