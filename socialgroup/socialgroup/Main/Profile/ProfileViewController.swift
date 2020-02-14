//
//  ProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let screenWidth = UIDevice.SCREEN_WIDTH
    let screenHeight = UIDevice.SCREEN_HEIGHT
    let backgroundHeight = UIDevice.SCREEN_WIDTH / 2
    let padding:CGFloat = 10
    let avatarHeight = UIDevice.SCREEN_WIDTH / 3
    let stickButtonHeight:CGFloat = 40
    let stickCountLabelHeight:CGFloat = 20
    let stickCountLabelWidth:CGFloat = 30
    
    var tableView:UITableView?
    var backgroundView = UIImageView(image: UIImage(named: "girls"))
    var backgroundShadowView = UIView()
    var avatarView = UIImageView(image: UIImage(named: "placeholder"))
    var avatarShadowView = UIView()
    var stickButton = UIButton()
    var stickCountLabel = UILabel()
    
    
    //gesture
    var panOriginPoint:CGPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        initTableView()
        initBackgroundView()
        initAvatarView()
        initStickButton()
        initStickCountLabel()
        initHeaderViewPanGesture()
        
    }
    
    //MARK:- init UI
    
    func initTableView(){
        //tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT))
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = .darkGray
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets(top: backgroundHeight - UIDevice.STATUS_BAR_HEIGHT, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView!)
    }
    
    func initBackgroundView(){
        //backgroundView
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.frame = CGRect(x: 0, y: 0, width: screenWidth, height:backgroundHeight)
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        //backgroundView shadow
        backgroundShadowView.frame = backgroundView.frame
        backgroundShadowView.backgroundColor = .black
        backgroundShadowView.alpha = 0.2
        view.addSubview(backgroundShadowView)
        
    }
    
    func initAvatarView(){
        //avatarView
        avatarView.frame = CGRect(x: 0, y: 0, width: avatarHeight, height: avatarHeight)
        avatarView.contentMode = .scaleAspectFill

        let avatarImageLayer: CALayer = avatarView.layer
        avatarImageLayer.masksToBounds = true
        avatarImageLayer.cornerRadius = avatarHeight / 2
        avatarImageLayer.borderWidth = 1
        avatarImageLayer.borderColor = UIColor.white.cgColor
        //avatar shadow
        avatarShadowView.frame = CGRect(x: padding, y: backgroundView.frame.maxY - avatarHeight - padding, width: avatarHeight, height: avatarHeight)
        avatarShadowView.layer.shadowColor = UIColor.black.cgColor
        avatarShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        avatarShadowView.layer.shadowOpacity = 0.5
        avatarShadowView.layer.shadowRadius = 4
        avatarShadowView.layer.cornerRadius = avatarHeight / 2
        avatarShadowView.clipsToBounds = false
        avatarShadowView.addSubview(avatarView)
        
        view.addSubview(avatarShadowView)
    }
    
    func initStickButton(){
        //stick button
        stickButton.setImage(UIImage(named: "stick"), for: .normal)
        stickButton.frame = CGRect(x: backgroundView.frame.maxX - stickButtonHeight - padding, y: backgroundView.frame.maxY - stickButtonHeight - padding - stickCountLabelHeight, width: stickButtonHeight, height: stickButtonHeight)
        stickButton.backgroundColor = .none
        //stickButton shadow
        stickButton.layer.shadowOpacity = 0.5
        stickButton.layer.shadowColor = UIColor.black.cgColor
        stickButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        stickButton.layer.shadowRadius = 3
        view.addSubview(stickButton)
    }
    
    func initStickCountLabel(){
        //stickCountLabel
        stickCountLabel.frame = CGRect(x: backgroundView.frame.maxX - stickCountLabelWidth - padding, y: backgroundView.frame.maxY - padding, width: stickCountLabelWidth, height: stickCountLabelHeight)
        stickCountLabel.text = "99"
        stickCountLabel.font = .systemFont(ofSize: 12)
        stickCountLabel.textColor = .white
        stickCountLabel.textAlignment = .center
        //stickCountLabel shadow
        stickCountLabel.layer.shadowOpacity = 1
        stickCountLabel.layer.shadowColor = UIColor.black.cgColor
        stickCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        stickCountLabel.layer.shadowRadius = 5
        view.addSubview(stickCountLabel)
    }
    
    func initHeaderViewPanGesture(){
        
        let bgSwipeGesture = HeaderGetureRecognizer(target: self, action: #selector(headerViewPanGestureAction(_:)))
//        let avSwipeGesture = HeaderGetureRecognizer(target: self, action: #selector(headerViewPanGestureAction(_:)))
//        let stickCSwipeGesture = HeaderGetureRecognizer(target: self, action: #selector(headerViewPanGestureAction(_:)))
//        let stickBSwipeGetsture = HeaderGetureRecognizer(target: self, action: #selector(headerViewPanGestureAction(_:)))
        backgroundShadowView.addGestureRecognizer(bgSwipeGesture)
//        avatarShadowView.addGestureRecognizer(avSwipeGesture)
//        stickCountLabel.addGestureRecognizer(stickCSwipeGesture)
//        stickButton.addGestureRecognizer(stickBSwipeGetsture)
    }
    
    //MARK:- Gesture / Action
    @objc func headerViewPanGestureAction(_ recognizer: HeaderGetureRecognizer){
        
        tableView!.contentOffset.y = tableView!.contentOffset.y - recognizer.movePoint.y
        print(recognizer.movePoint.y)
        
        if(recognizer.touchEnded && tableView!.contentOffset.y < -backgroundHeight){
//            tableView?.setContentOffset(CGPoint(x: 0, y: -backgroundHeight), animated: true)
            tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            
        }
    }
    

    //MARK:- tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var backgroundFrame = self.backgroundView.frame
        var avatarShadowFrame = self.avatarShadowView.frame
        var stickButtonFrame = self.stickButton.frame
        var stickCountLabelFrame = self.stickCountLabel.frame
        if offsetY < -backgroundHeight {
            //壁纸下移
            backgroundFrame.origin.y = 0 // 这句代码一定要加  不然会出点问题
            backgroundFrame.size.height = -offsetY
            avatarShadowFrame.origin.y = -offsetY - avatarHeight - padding
            stickButtonFrame.origin.y = -offsetY - stickButtonHeight - padding - stickCountLabelHeight
            stickCountLabelFrame.origin.y = -offsetY - stickCountLabelHeight - padding
        } else {
            //壁纸上移
            backgroundFrame.origin.y = -(backgroundHeight + offsetY)
            backgroundFrame.size.height = backgroundHeight
            avatarShadowFrame.origin.y = -(avatarHeight + offsetY + padding)
            avatarShadowFrame.size.height = avatarHeight
            stickButtonFrame.origin.y = -(stickButtonHeight + offsetY + padding + stickCountLabelHeight)
            stickButtonFrame.size.height = stickButtonHeight
            stickCountLabelFrame.origin.y = -(stickCountLabelHeight + offsetY + padding)
            stickCountLabelFrame.size.height = stickCountLabelHeight
        }
        
        self.backgroundView.frame = backgroundFrame
        self.avatarShadowView.frame = avatarShadowFrame
        self.stickButton.frame = stickButtonFrame
        self.stickCountLabel.frame = stickCountLabelFrame
        self.backgroundShadowView.frame = backgroundFrame
    }

    

}



