//
//  ImageBrowserTranslation.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/20.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit

class ImageBrowserTranslation:NSObject, UIViewControllerAnimatedTransitioning {
    
    
    var isBrowserMainView:Bool!
    var mainBrowserMainView:ImageBrowserMainView!
    var browserControllerView:UIView!
    
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let dataM = self.mainBrowserMainView.dataSource
        let currentIndex = self.mainBrowserMainView.selectPage!
        
        let currentModel = dataM[currentIndex]
        
        let containerView = transitionContext.containerView
        
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        if(self.isBrowserMainView){
            //进入
            containerView.addSubview(toViewController.view)
            let frame = currentModel.smallImageViewframeOriginWindow()
            let image = currentModel.getCurrentImage()
            let imageView = self.addShadowImageViewWithFrame(frame: frame, image: image)
            //隐藏子组件
            self.mainBrowserMainView.subViewHidden(isHidden: true)
            self.browserControllerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            currentModel.smallImageView.isHidden = true
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                imageView.frame = currentModel.imageViewframeShowWindow()
                self.browserControllerView.backgroundColor = UIColor.black.withAlphaComponent(1.0)
            }) { (finished) in
                if(transitionContext.transitionWasCancelled){
                    transitionContext.completeTransition(false)
                }else{
                    transitionContext.completeTransition(true)
                    self.mainBrowserMainView.subViewHidden(isHidden: false)
                    imageView.removeFromSuperview()
                }
            }
            
        }else{
            //是离开
            let frame = currentModel.bigImageViewFrameOnScrollView()
            let image = currentModel.getCurrentImage()
            let imageView = self.addShadowImageViewWithFrame(frame: frame, image: image)
            
            self.mainBrowserMainView.subViewHidden(isHidden: true)
            
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                imageView.frame = currentModel.smallImageViewframeOriginWindow()
                self.browserControllerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            }) { (finished) in
                if(transitionContext.transitionWasCancelled){
                    transitionContext.completeTransition(false)
                }else{
                    transitionContext.completeTransition(true)
                    imageView.removeFromSuperview()
                    currentModel.smallImageView?.isHidden = false
                }
            }
            
        }
        
    }
    
    
    func addShadowImageViewWithFrame(frame:CGRect, image:UIImage) -> UIImageView{
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        self.browserControllerView.addSubview(imageView)
        return imageView
    }
    
}
