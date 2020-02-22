//
//  ImageBrowserManager.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/20.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit

class ImageBrowserManager:NSObject{
    /**
    初始化 Manger
    
    @param imageUrls 各个图片大图的url
    @param originImageViews 原始的小图
    @param controller 小图所有的视图控制器
    @param forceTouchCapability 是否开启3Dtouch
    @param titles 3Dtouch 上滑事件的title，可为 nil
    @param forceTouchActionBlock 设置的3Dtouch 上滑事件的的回调，可为 nil
    @return manger
    */
    
    var imageUrls:[String]!
    var originImageViews:[UIImageView]!
    var controller:UIViewController!
    var selectPage:Int!
    var previewActionTitles:[String]!
    var imageBrowserManager:ImageBrowserManager!
    
    func imageBrowserManagerWithUrlStr(imageUrls: [String], originalImageViews: [UIImageView], controller: UIViewController, titles:[String]){
        
        imageBrowserManager = ImageBrowserManager()
        imageBrowserManager.imageUrls = imageUrls
        imageBrowserManager.originImageViews = originImageViews
        imageBrowserManager.controller = controller
        
        
        self.imageUrls = imageUrls
        self.originImageViews = originalImageViews
        self.controller = controller
        
    }
    
    func showImageBrowser(){
        let imageBrowserViewController = ImageBrowserViewController(imageUrls: self.imageUrls, originImageViews: originImageViews, selectPage: selectPage)
//        imageBrowserViewController.modalPresentationStyle = .overFullScreen
        self.controller.present(imageBrowserViewController, animated: true, completion: nil)
    }
    
}

extension ImageBrowserManager{
    
    //MARK:- UIViewControllerPreviewingDelegate
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        <#code#>
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        <#code#>
//    }
}
