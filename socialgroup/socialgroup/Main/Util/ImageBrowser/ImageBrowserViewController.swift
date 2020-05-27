//
//  ImageBrowserViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/20.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class ImageBrowserViewController: BaseViewController, UIViewControllerTransitioningDelegate, ImageBrowserMainViewDelegate {
    /**
    初始化查看大图的controller

    @param imageUrls 所有大图的数组
    @param originImageViews 所有小图原始的imageView数组
    @param selectPage 选中的是第几个
    @return 大图的controller
    */

    
    var imageUrls:[String]!
    var originImageViews:[UIImageView]!
    var selectPage:Int!
    
    
    lazy var browserMainView:ImageBrowserMainView = {
        let browserMainView = ImageBrowserMainView(imageUrls: self.imageUrls, originImageViews: self.originImageViews, selectPage: self.selectPage)
        browserMainView.delegate = self
        return browserMainView
    }()
    
    lazy var browserTranslation:ImageBrowserTranslation = {
        let browserTransition = ImageBrowserTranslation()
        browserTransition.mainBrowserMainView = self.browserMainView
        browserTransition.browserControllerView = self.view
        return browserTransition
        
    }()
    var controller:UIViewController!
    
    
    
    
    init(imageUrls:[String], originImageViews:[UIImageView], selectPage:Int){
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self
        self.imageUrls = imageUrls
        self.originImageViews = originImageViews
        self.selectPage = selectPage
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        view.backgroundColor = .black
        view.addSubview(self.browserMainView)
        
        //添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressClick))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(longPress)
        
    }
    
     //长按手势事件
    @objc func longPressClick() {
        let alert = UIAlertController(title: "请选择", message: nil, preferredStyle: .actionSheet)
//        let action = UIAlertAction(title: "保存到相册", style: .default) { [weak self](_) in
        //按着command键，同时点击UIImageWriteToSavedPhotosAlbum方法可以看到
//        UIImageWriteToSavedPhotosAlbum(self!.subImageView.image!, self!, #selector(self!.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
        let action = UIAlertAction(title: "保存到相册", style: .default) { (alert) in
//            UIImageWriteToSavedPhotosAlbum(self.originImageViews[self.selectPage].image!, self, #selector(saveImageResponse(_:didFinishSavingWithError:contextInfo:)), nil )
            let select = self.browserMainView.selectPage!
            let image = self.browserMainView.dataSource[select].bigImageView.image
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.saveImageResponse(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
            
    }
    
    //保存二维码
    @objc func saveImageResponse(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            self.showTempAlert(info: "保存成功")
        } else {
            self.showTempAlert(info: "保存失败")
        }
    }
    

}


extension ImageBrowserViewController{
    
    //MARK:- ImageBrowserMainViewDelegate
    func imageBrowserMainViewSingleTapWithModel(imageBrowserModel: ImageBrowserModel) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageBrowserMainViewTouchMoveChangeMainViewAlpha(alpha: CGFloat) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
    }
    
    //MARK:- UIViewControllerTRansitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.browserTranslation.isBrowserMainView = true
        return self.browserTranslation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.browserTranslation.isBrowserMainView = false
        return self.browserTranslation
    }
    
    
}
