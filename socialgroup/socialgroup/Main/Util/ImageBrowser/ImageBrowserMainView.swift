//
//  ImageBrowserMainView.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/20.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol ImageBrowserMainViewDelegate:NSObjectProtocol {
    func imageBrowserMainViewSingleTapWithModel(imageBrowserModel:ImageBrowserModel)
    func imageBrowserMainViewTouchMoveChangeMainViewAlpha(alpha:CGFloat)
}


class ImageBrowserMainView: UIView, UIScrollViewDelegate, ImageBrowserSubViewDelegate {
    
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    let ScreenHeight = UIDevice.SCREEN_HEIGHT
    let SpaceWidth:CGFloat = 20

    lazy var mainScrollView:UIScrollView = {
        let mainScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH + 20.0, height: UIDevice.SCREEN_HEIGHT))
        mainScrollView.delegate = self
        mainScrollView.backgroundColor = .clear
        mainScrollView.isPagingEnabled = true
        mainScrollView.showsHorizontalScrollIndicator = false
        return mainScrollView
    }()
    
    lazy var pageController:UIPageControl = {
        let pageController = UIPageControl()
        pageController.hidesForSinglePage = true
        pageController.pageIndicatorTintColor = .gray
        pageController.currentPageIndicatorTintColor = .white
        return pageController
    }()
    
    var imageUrls:[String]!
    var originImageViews:[UIImageView]!
    var dataSource:[ImageBrowserModel] = []
    var selectPage:Int!
    
    
    var delegate:ImageBrowserMainViewDelegate?
    
    
    init(imageUrls:[String], originImageViews:[UIImageView], selectPage:Int) {
       super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))

        self.imageUrls = imageUrls
        self.originImageViews = originImageViews
        self.selectPage = selectPage
        
        
        self.initData()
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(){
        for i in 0..<self.imageUrls.count{
            let urlStr = self.imageUrls[i]
            let imageView = self.originImageViews[i]
            let imageBrowserModel = ImageBrowserModel()
            imageBrowserModel.smallImageView = imageView
            imageBrowserModel.urlStr = urlStr
            self.dataSource.append(imageBrowserModel)
        }
    }
    
    func initView(){
        //1.初始化 mianScrollView
        self.addSubview(self.mainScrollView)
        //加入子视图
        for i in 0..<self.dataSource.count{
            let imageBrowserSubView = ImageBrowserSubView(frame: CGRect(x: (ScreenWidth + SpaceWidth)*CGFloat(i), y: 0, width: ScreenWidth, height: ScreenHeight), imageBrowserModel: self.dataSource[i])
            
            imageBrowserSubView.delegate = self
            self.mainScrollView.addSubview(imageBrowserSubView)
        }
        
        self.mainScrollView.contentSize = CGSize(width: (ScreenWidth + SpaceWidth)*CGFloat(self.dataSource.count), height: 0)
        self.mainScrollView.contentOffset = CGPoint(x: (ScreenWidth + SpaceWidth)*CGFloat(selectPage), y: 0)
        //2.设置 pagecontel
        self.addSubview(pageController)
        pageController.numberOfPages = dataSource.count
        let size = pageController.size(forNumberOfPages: self.dataSource.count)
        pageController.frame = CGRect(x: ScreenWidth/2-size.width/2, y: ScreenHeight-size.height-20, width: size.width, height: size.height)
        pageController.currentPage = self.selectPage

        
    }
    
    func subViewHidden(isHidden:Bool){
        if(isHidden){
            self.mainScrollView.isHidden = true
            self.pageController.isHidden = true
        }else{
            self.mainScrollView.isHidden = false
            self.pageController.isHidden = false
        }
    }
}

extension ImageBrowserMainView{
    
    //MARK:- ImageBrowserSubViewDelegate
    func imageBrowserSubViewSingleTapWithModel(imageBrowserModel: ImageBrowserModel) {
        self.delegate?.imageBrowserMainViewSingleTapWithModel(imageBrowserModel: imageBrowserModel)
    }
    
    func imageBrowserSubViewTouchMoveChangeMainViewAlpha(alpha: CGFloat) {
        self.delegate?.imageBrowserMainViewTouchMoveChangeMainViewAlpha(alpha: alpha)
    }
    
    //MARK:- scrollview delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentX = scrollView.contentOffset.x
        let currentPage = Int(currentX / (ScreenWidth + SpaceWidth))
        self.selectPage = currentPage
        self.pageController.currentPage = currentPage
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentX = scrollView.contentOffset.x
        let currentPage = Int(currentX / (ScreenWidth + SpaceWidth))
        self.pageController.currentPage = currentPage
        for view in originImageViews{
            view.isHidden = false
        }
        originImageViews[currentPage].isHidden = true
    }
    
}
