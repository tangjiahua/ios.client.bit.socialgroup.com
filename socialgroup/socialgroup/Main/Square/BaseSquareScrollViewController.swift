//
//  BaseScrollVC.swift
//  Mask
//
//  Created by 汤佳桦 on 2019/11/2.
//  Copyright © 2019 Beijing Institute of Technology. All rights reserved.
//

import UIKit


let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height
let TitleFont:UIFont = UIFont.systemFont(ofSize: 15)//标题的大小
let TitleHeight:CGFloat = 40.0//标题滚动视图的高度
let UnderlineHeight:CGFloat = 4.0//自定义滑动条的高度
let Coler:UIColor = UIColor.label //标题选中的颜色

let ButtonStartTag:Int = 2000


class BaseSquareScrollViewController: UIViewController, UIScrollViewDelegate {
    var NavigationHeight:CGFloat = 64//导航栏的高度
    var titleScrollView:UIScrollView?//标题滚动视图
    var contentScollView:UIScrollView?//管理子控制器View的滚动视图
    var selectButton:UIButton?//保存选中的按钮
    var titleSButtons:NSMutableArray = NSMutableArray.init()//保存标题按钮的数组
    var selectIndex:Int = 0//选中的下标
    var isIninttial:Bool = true//第一次加载的变量
    let btnScale:CGFloat = 0.0//用于做过度的效果
    var underline:UIView?//自定义的滑动条
    
    //针对iPhoneX以后的设备进行单独处理
    var heightOfAddtionalFooter:CGFloat = {
        if UIDevice.current.isiPhoneXorLater(){
            return 34.0
        }else{
            return 0
        }
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.NavigationHeight = UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT
        setupTitleScrollViewFunction()
        setupContentScrollVewFunction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isIninttial {
            setupAllButtonTitle()
            setupUnderlineFunction()

            self.isIninttial = false
//            self.titleScrollView?.frame = CGRect(x: 0, y: UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT, width: self.titleScrollView!.frame.width, height: self.titleScrollView!.frame.height)
//            self.contentScollView?.frame = CGRect(x: 0, y: 0 , width: self.contentScollView!.frame.width, height: self.contentScollView!.frame.height)

        }

    }

    func setupTitleScrollViewFunction() -> Void{
        titleScrollView = UIScrollView.init(frame: CGRect(x: 0, y: UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT, width: ScreenWidth, height: TitleHeight))
        titleScrollView?.showsHorizontalScrollIndicator = false
        titleScrollView?.scrollsToTop = false
        titleScrollView?.backgroundColor = UIColor.secondarySystemBackground
//        titleScrollView?.backgroundColor = UIDevice.THEME_COLOR
            
            
        view.addSubview(titleScrollView!)
    
    }
    

    
    func setupContentScrollVewFunction() -> Void {
        contentScollView = UIScrollView(frame: CGRect(x: 0, y: UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT - UIDevice.NAVIGATION_BAR_HEIGHT - UIDevice.STATUS_BAR_HEIGHT))
        
        contentScollView?.showsVerticalScrollIndicator = false
        contentScollView?.showsHorizontalScrollIndicator = false
        contentScollView?.isPagingEnabled = true
        contentScollView?.bounces = true
        contentScollView?.alwaysBounceVertical = false
        contentScollView?.scrollsToTop = true
        contentScollView?.delegate = self
        contentScollView?.backgroundColor = .secondarySystemBackground
        view.insertSubview(contentScollView!, at: 0)
        
        
    }
    
    func setupAllButtonTitle() -> Void {
        
        let count:Int = self.children.count
        let btnW:CGFloat = ScreenWidth/CGFloat(count)
        
        for  i  in 0..<count {
            let button:UIButton = UIButton.init(type: .custom)
            let btnX:CGFloat = CGFloat(i)*btnW
            button.frame = CGRect(x: btnX, y: 0, width: btnW, height: TitleHeight-5)
            button.tag = ButtonStartTag+i
            button.titleLabel?.font = TitleFont
            let vc:UIViewController = self.children[i]
            
            button.setTitleColor(UIColor.label, for: .normal)
            button.setTitleColor(UIColor.label, for: .selected)
            button.setTitle(vc.title, for: .normal)
            titleScrollView?.addSubview(button)
            titleSButtons.add(button)
            button.addTarget(self, action: #selector(titleclickAction(sender:)), for: .touchUpInside)
            
        }
        dealBtnClickAction(sender: titleSButtons[selectIndex] as! UIButton)
        
        titleScrollView?.contentSize = CGSize.init(width: CGFloat(count)*btnW, height: TitleHeight)
        contentScollView?.contentSize = CGSize.init(width: CGFloat(count)*ScreenWidth, height: ScreenWidth-TitleHeight-NavigationHeight)
        
    }
    
    func setupUnderlineFunction(){
        let firstTitleButton:UIButton = titleScrollView?.subviews.first as! UIButton
        
        let underlineView = UIView.init()
        underlineView.frame = CGRect.init(x: 0, y: TitleHeight-UnderlineHeight, width: 70, height: UnderlineHeight)
        underlineView.backgroundColor = .systemFill
        titleScrollView?.addSubview(underlineView)
        underline = underlineView
        
        firstTitleButton.titleLabel?.sizeToFit()
        
        underline?.frame.size.width = (firstTitleButton.titleLabel?.frame.size.width)! + 10
        underline?.center.x = firstTitleButton.center.x
        
        let lineLayer = UIView.init()
        lineLayer.backgroundColor = UIColor.secondarySystemBackground
        lineLayer.frame = CGRect.init(x: 0, y: TitleHeight-1, width: ScreenWidth, height: 1)
        titleScrollView?.addSubview(lineLayer)
        
    
    }
    
    @objc func titleclickAction(sender:UIButton) -> Void {
     
            dealBtnClickAction(sender: sender)
        
    }
    func setupTitleCenterFunction(sender:UIButton) -> Void {
        var offsetX:CGFloat = sender.center.x - ScreenWidth*0.5
        if offsetX<0 {
            offsetX = 0
        }
        
        let maxoffsetX = (titleScrollView?.contentSize.width)! - ScreenWidth
        if offsetX>maxoffsetX {
            offsetX = maxoffsetX
        }
        
        titleScrollView?.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
    
    
    func adjustUnderLine(sender:UIButton) -> Void {
        underline?.frame.size.width = (sender.titleLabel?.frame.size.width)!+10
        underline?.center.x = sender.center.x
        
    }
    func selectTitleButton(sender:UIButton) -> Void {
        selectButton?.setTitleColor(UIColor.label, for: .normal)
        sender.setTitleColor(UIColor.label, for: .normal)
        let scale:CGFloat = 1 + btnScale
        
        selectButton?.transform = CGAffineTransform.identity
        sender.transform = CGAffineTransform.init(scaleX: scale, y: scale)

        selectButton = sender
    }
    func dealBtnClickAction(sender:UIButton) -> Void {
        
        
        let index = sender.tag - ButtonStartTag
        selectTitleButton(sender: sender)
        setupOneChildViewController(index: index)
        contentScollView?.contentOffset = CGPoint.init(x: CGFloat(index)*ScreenWidth, y: 0)
        
        UIView.animate(withDuration: 0.25) {
            
            self.adjustUnderLine(sender: sender)
            
        }
        for i in 0..<titleSButtons.count{
            if !(i==index){
                showTitleScrollView()
                let noSelectBtn:UIButton = titleSButtons[i] as! UIButton
                noSelectBtn.setTitleColor(UIColor.secondaryLabel, for: .normal)
            
            }
        }
        
        for i in 0..<children.count{
            let chilaCtl:UIViewController = self.children[i]
            if !chilaCtl.isViewLoaded {
                continue
            }
        
            let childVcView:UIView = chilaCtl.view
            if childVcView.isKind(of: UIScrollView.classForCoder()) {
                let scrollView:UIScrollView = childVcView as! UIScrollView
                scrollView.scrollsToTop = (i == index)
                if i == index {
                    
                }
            }
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/ScreenWidth
        let leftIndex:Int = Int(value)
        let rightIndex = leftIndex+1
        let scaleRight:CGFloat = scrollView.contentOffset.x/ScreenWidth - CGFloat(leftIndex)
//        let scaleLeft:CGFloat = 1 - scaleRight
//        let leftTitleBtn:UIButton = self.titleSButtons[leftIndex] as! UIButton
//        leftTitleBtn.ButtonColorScale(scaleLeft)
        
        
        if rightIndex < self.titleSButtons.count {
            let rightTitleBtn:UIButton = self.titleSButtons[rightIndex] as! UIButton
//            rightTitleBtn.ButtonColorScale(scaleRight)
            rightTitleBtn.transform = CGAffineTransform.init(scaleX: scaleRight*self.btnScale+1, y: scaleRight*self.btnScale+1)
            
        }
        
        setupOneChildViewController(index: rightIndex)
    }
    
    func setupOneChildViewController(index:Int) -> Void {
        if index>=self.children.count {
            return
        }
        let vc:UIViewController = self.children[index]
        if (vc.view.superview != nil) {
            return
        }
        
        let offX = CGFloat(index)*ScreenWidth
        vc.view.frame = CGRect.init(x: offX, y: 0, width: ScreenWidth, height: (contentScollView?.frame.size.height)!)
        contentScollView?.addSubview(vc.view)
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(scrollView.contentOffset.x/ScreenWidth)
        let button:UIButton = titleSButtons[index] as! UIButton
        dealBtnClickAction(sender: button)
        
    }
    
    func showTitleScrollView(){
        
    }
    
    func hideTitleScrollView(){
        
    }
    
    
}



