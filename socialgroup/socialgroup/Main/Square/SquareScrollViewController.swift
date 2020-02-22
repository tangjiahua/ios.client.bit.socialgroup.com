//
//  SquareViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SquareScrollViewController: BaseSquareScrollViewController, BroadcastViewControllerDelegate {
    
    
    
    var broadcastVC: BroadcastViewController!
    var circleVC: CircleViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barTintColor = UIColor.secondarySystemBackground
        self.view.backgroundColor = UIColor.secondarySystemBackground
        self.title = "广场"
        
        broadcastVC = BroadcastViewController()
        broadcastVC.view.backgroundColor = .secondarySystemBackground
        broadcastVC.title = "广播"
        broadcastVC.delegate = self
        
        circleVC = CircleViewController()
        circleVC.view.backgroundColor = .secondarySystemBackground
        circleVC.title = "动态"
        
        
        self.addChild(self.broadcastVC)
        self.addChild(self.circleVC)
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- BroadcastVC delegate
    func hideTitleScrollView() {
        UIView.animate(withDuration: 0.2) {
            super.titleScrollView?.alpha = 0
        }
    }
    
    func showTitleScrollView() {
        UIView.animate(withDuration: 0.2) {
            super.titleScrollView?.alpha = 1
        }
    }
    
}
