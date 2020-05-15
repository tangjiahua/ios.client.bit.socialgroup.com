//
//  SquareViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SquareScrollViewController: BaseSquareScrollViewController, BroadcastViewControllerDelegate, CircleViewControllerDelegate, BasePushViewControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    var broadcastVC: BroadcastViewController!
    var circleVC: CircleViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        
        self.title = "广场"
        
        broadcastVC = BroadcastViewController()
        broadcastVC.view.backgroundColor = .secondarySystemBackground
        broadcastVC.title = "广播"
        broadcastVC.delegate = self
        
        circleVC = CircleViewController()
        circleVC.view.backgroundColor = .secondarySystemBackground
        circleVC.title = "动态"
        circleVC.delegate = self
        
        
        self.addChild(self.broadcastVC)
        self.addChild(self.circleVC)
        
        // right buttons
        initPushButton()
        // left buttons
        initSocialGroupView()
        
        // pop Gesture
        let popGesture = self.navigationController!.interactivePopGestureRecognizer
        let popTarget = popGesture?.delegate
        let popView = popGesture!.view!
        popGesture?.isEnabled = false
        
        let popSelector = NSSelectorFromString("handleNavigationTransition:")
        let fullScreenPoGesture = UIPanGestureRecognizer(target: popTarget, action: popSelector)
        fullScreenPoGesture.delegate = self
        
        popView.addGestureRecognizer(fullScreenPoGesture)
        
    }
    
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController!.viewControllers.count > 1 {
              return true
          }
         return false
    }
    
    func initPushButton(){
        let pushButtom = UIBarButtonItem(image: UIImage(named: "push-black"), style: .plain, target: self, action: #selector(push))
        self.navigationItem.rightBarButtonItems = [pushButtom]
    }
    
    func initSocialGroupView(){
    }
    
    @objc func push(){
        let pushTappedSheet = UIAlertController.init(title: "发布", message: nil, preferredStyle: .actionSheet)
        self.present(pushTappedSheet, animated: true, completion: nil)
        pushTappedSheet.addAction(.init(title: "发布广播", style: .default, handler:{(action: UIAlertAction) in
            let broadcastPushVC = BroadcastPushViewController()
            broadcastPushVC.delegate = self
            let broadcastPushNC = UINavigationController(rootViewController: broadcastPushVC)
            broadcastPushNC.modalPresentationStyle = .fullScreen
            self.present(broadcastPushNC, animated: true, completion: nil)
        } ))
        pushTappedSheet.addAction(.init(title: "发布动态", style: .default, handler:{(action: UIAlertAction) in
            let circlePushVC = CirclePushViewController()
            let circlePushNC = UINavigationController(rootViewController: circlePushVC)
            circlePushVC.delegate = self
            circlePushNC.modalPresentationStyle = .fullScreen
            self.present(circlePushNC, animated: true, completion: nil)
        } ))
        pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- BroadcastVC delegate
    override func hideTitleScrollView() {
        UIView.animate(withDuration: 0.2) {
            super.titleScrollView?.alpha = 0
        }
    }
    
    override func showTitleScrollView() {
        UIView.animate(withDuration: 0.2) {
            super.titleScrollView?.alpha = 1
        }
    }
    
    
    // MARK:- BasePushViewCOnytroller delegate
    func pushSuccess() {
        broadcastVC.refreshBroadcast()
        circleVC.refreshCircle()
    }
    
}
