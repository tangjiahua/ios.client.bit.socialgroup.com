//
//  ImageBrowserSubview.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/20.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SDWebImage

protocol ImageBrowserSubViewDelegate:NSObjectProtocol {
    func imageBrowserSubViewSingleTapWithModel(imageBrowserModel:ImageBrowserModel)
    func imageBrowserSubViewTouchMoveChangeMainViewAlpha(alpha:CGFloat)
}

class ImageBrowserSubView: UIView, UIScrollViewDelegate {
    
    var delegate:ImageBrowserSubViewDelegate?
    
    var imageBrowserModel:ImageBrowserModel!
    var subScrollView:UIScrollView!
    var subImageView:UIImageView!
    var touchFingerNumber:Int!
    
    init(frame:CGRect, imageBrowserModel:ImageBrowserModel) {
        super.init(frame: frame)
        
        self.imageBrowserModel = imageBrowserModel
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        subScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT))
        subScrollView.delegate = self
        subScrollView.bouncesZoom = true
        subScrollView.maximumZoomScale = 2.5
        subScrollView.minimumZoomScale = 1.0
        subScrollView.isMultipleTouchEnabled = true
        subScrollView.scrollsToTop = false
        subScrollView.contentSize = CGSize(width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT)
        subScrollView.isUserInteractionEnabled = true
        subScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subScrollView.delaysContentTouches = false
        subScrollView.canCancelContentTouches = false
        subScrollView.alwaysBounceVertical = true
        subScrollView.showsVerticalScrollIndicator = false
        subScrollView.showsHorizontalScrollIndicator = false
        subScrollView.contentInsetAdjustmentBehavior = .never
        
        
        subImageView = UIImageView()
        subImageView.contentMode = .scaleAspectFit
        
        
        
        self.addSubview(subScrollView)
        self.subScrollView.addSubview(self.subImageView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        self.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        singleTap.require(toFail: doubleTap)
        self.addGestureRecognizer(doubleTap)
        
        
        self.imageBrowserModel.bigScrollView = self.subScrollView
        self.imageBrowserModel.bigImageView = self.subImageView
        
        //    __weak typeof (self)ws = self;
        
        self.subImageView.sd_setImage(with: URL(string: imageBrowserModel.urlStr), placeholderImage: imageBrowserModel.smallImageView.image, options: [.refreshCached]) { (image, error, cachetype, imageURL) in
            if(error == nil){
                self.updateSubScrollViewSubImageView()
            }
        }
        
        
        self.updateSubScrollViewSubImageView()
        
        
    }
    
    
    @objc func singleTapAction(singleTap: UITapGestureRecognizer){
        self.delegate?.imageBrowserSubViewSingleTapWithModel(imageBrowserModel: self.imageBrowserModel)
    }
    
    
    @objc func doubleTapAction(doubleTap: UITapGestureRecognizer){
        if(self.subScrollView.zoomScale > 1.0){
            self.subScrollView.setZoomScale(1.0, animated: true)
        }else{
            let touchPoint = doubleTap.location(in: self.subImageView)
            let maxZoomScale = self.subScrollView.maximumZoomScale
            let width = self.frame.size.width / maxZoomScale
            let height = self.frame.size.height / maxZoomScale
            self.subScrollView.zoom(to: CGRect(x: touchPoint.x - width/2, y: touchPoint.y - height / 2, width: width, height: height), animated: true)
        }
    }
    
    func updateSubScrollViewSubImageView(){
        self.subScrollView.setZoomScale(1.0, animated: false)
        
        let imageW = self.imageBrowserModel.bigImageSize.width
        let imageH = self.imageBrowserModel.bigImageSize.height
        
        let height = UIDevice.SCREEN_WIDTH * imageH/imageW
        
        if(imageH/imageW > UIDevice.SCREEN_HEIGHT/UIDevice.SCREEN_WIDTH){
            //长图
            self.subImageView.frame = CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: height)
        }else{
            self.subImageView.frame = CGRect(x: 0, y: UIDevice.SCREEN_HEIGHT/2 - height/2, width: UIDevice.SCREEN_WIDTH, height: height)
        }
        self.subScrollView.contentSize = CGSize(width: UIDevice.SCREEN_WIDTH, height: height)
    }
    
    
    //MARK:- scrollView delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.subImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        self.subImageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let subScrollViewPan = scrollView.panGestureRecognizer
        self.touchFingerNumber = subScrollViewPan.numberOfTouches
        self.subScrollView.clipsToBounds = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        //只有一根手指事件才做出响应
        if(contentOffsetY < 0 && self.touchFingerNumber == 1){
            self.changeSizeCenterY(contentOffsetY: contentOffsetY)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentOffsetY = scrollView.contentOffset.y
        
        if((contentOffsetY<0 && self.touchFingerNumber == 1) && (velocity.y<0 && abs(velocity.y)>abs(velocity.x))){
            //如果是向下划触发消失的操作
            self.delegate?.imageBrowserSubViewSingleTapWithModel(imageBrowserModel: self.imageBrowserModel)
            
        }else{
            self.changeSizeCenterY(contentOffsetY: 0.0)
            let offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0
            let offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0
            self.subImageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        }
        
        self.touchFingerNumber = 0
        self.subScrollView.clipsToBounds = true
        
    }
    
    func changeSizeCenterY(contentOffsetY:CGFloat){
        var multiple = (UIDevice.SCREEN_HEIGHT + contentOffsetY*1.75) / UIDevice.SCREEN_HEIGHT
        self.delegate?.imageBrowserSubViewTouchMoveChangeMainViewAlpha(alpha: multiple)
        
        multiple = multiple > 0.4 ? multiple : 0.4
        self.subScrollView.transform = CGAffineTransform(scaleX: multiple, y: multiple)
        self.subScrollView.center = CGPoint(x: UIDevice.SCREEN_WIDTH / 2, y: UIDevice.SCREEN_HEIGHT/2 - contentOffsetY * 0.5)
    }
    
    
    //MARK:- lazy
    
    
}
