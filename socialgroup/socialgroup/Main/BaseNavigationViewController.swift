//
//  BaseNavigationViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/6/6.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit


class BaseNavigationViewController: BaseViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    var viewIsInTransition = false
    var fullScreenPoGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopGesture()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
//        print("disappear")
        viewIsInTransition = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        print("view did disappear")
        viewIsInTransition = false
    }
    
    
    
    func setPopGesture(){
        // pop Gesture
        
        if let popGesture = self.navigationController?.interactivePopGestureRecognizer{
            let popTarget = popGesture.delegate
                    let popView = popGesture.view!
                    popGesture.isEnabled = false

                    let popSelector = NSSelectorFromString("handleNavigationTransition:")
                    fullScreenPoGesture = UIPanGestureRecognizer(target: popTarget, action: popSelector)
            //        let fullScreenPoGesture = UITapGestureRecognizer(target: popTarget, action: popSelector)
                    fullScreenPoGesture.delegate = self

                    popView.addGestureRecognizer(fullScreenPoGesture)
        }
        
//        let popGesture = self.navigationController?.interactivePopGestureRecognizer
        
    }
    
    
    
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(self.navigationController?.viewControllers.count ?? 0)
    
        
        
        if self.navigationController!.viewControllers.count > 1 && !viewIsInTransition {
              return true
          }
        
        
         return false
    }

}
