//
//  ProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SDWebImage



class BaseProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var heightForTableView:CGFloat{
        //照片墙高度
        var wallCollectionViewHeight:CGFloat
        let count = Int(profileModel.wallPhotosCount)!
        let itemHeight:CGFloat = (screenWidth - padding*4)/3
        if(count == 0){
            wallCollectionViewHeight = 0
        }else if(count > 0 && count <= 3){
            wallCollectionViewHeight = itemHeight + padding*2
        }else{
            wallCollectionViewHeight = itemHeight*2 + padding*2
        }
        
        //最终返回
        if(profileModel.isPrivateAbleToSee){
            return smallpadding + nicknameLabelHeight + smallpadding + realnameLabelHeight + padding + 160 + padding + publicIntroductionLabelHeight + padding + wallCollectionViewHeight + padding + publicIntroductionLabelHeight + padding + publicIntroductionViewHeight + 20 + padding + publicIntroductionLabelHeight + padding + privateIntroductionTextViewHeight + 20 + 30
        }else{
            return smallpadding + nicknameLabelHeight + smallpadding + realnameLabelHeight + padding + 160 + padding + publicIntroductionLabelHeight + padding + wallCollectionViewHeight + padding + publicIntroductionLabelHeight + padding + publicIntroductionViewHeight + 20 + padding + publicIntroductionLabelHeight + padding + 30
        }
    }
    
    
    //记录cell的数据
    let nicknameFontSize:CGFloat = 30
    let nicknameLabelHeight:CGFloat = 30
    let realnameLabelHeight:CGFloat = 18
    let publicIntroductionLabelFontSize:CGFloat = 20
    let publicIntroductionLabelHeight:CGFloat = 20
    let publicIntroductionTextViewFonrSize:CGFloat = 16
    let publicIntroductionTextViewMinimunHeight:CGFloat = 100
    let publicIntroductionViewHeight:CGFloat = 300
    let privateIntroductionTextViewHeight:CGFloat = 200
    
    
    
    //basic ui
    let screenWidth = UIDevice.SCREEN_WIDTH
    let screenHeight = UIDevice.SCREEN_HEIGHT
    let backgroundHeight = UIDevice.SCREEN_WIDTH * 2 / 3
    let padding:CGFloat = 10
    let smallpadding:CGFloat = 5
    let avatarHeight = UIDevice.SCREEN_WIDTH / 3
    let stickButtonHeight:CGFloat = 40
    let stickCountLabelHeight:CGFloat = 20
    let stickCountLabelWidth:CGFloat = 30
    let moreButtonHeight:CGFloat = 20
    let moreButtonWidth:CGFloat = 30
    
    var headerView = UIView()
    var tableView:UITableView?
    var backgroundView = UIImageView(image: UIImage(named: "placeholder"))
    var backgroundShadowView = UIView()
    var avatarView = UIImageView(image: UIImage(named: "placeholder"))
    var avatarShadowView = UIView()
    var stickButton = UIButton()
    var stickCountLabel = UILabel()
    var moreButton = UIButton()
    
    
    
    //model
    var profileModel:ProfileModel!
    
    //delegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
        
        initTableView()
        
        //init HeaderView
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: backgroundHeight)
        tableView?.tableHeaderView = headerView
        
        initBackgroundView()
        initAvatarView()
        initStickButton()
        initStickCountLabel()
        initMoreButton()
        
    
        //子类需要重写发生的事件的方法
        
        let avatarTapGestureRocognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTappedGesture))
        avatarShadowView.addGestureRecognizer(avatarTapGestureRocognizer)
        let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTappedGesture))
        backgroundShadowView.addGestureRecognizer(backgroundTapGestureRecognizer)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        stickButton.addTarget(self, action: #selector(stickButtonTapped), for: .touchUpInside)
        
        
    }
    
    //MARK:- init UI
    
    func initTableView(){
        //tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT))
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        tableView?.backgroundColor = .secondarySystemBackground
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets(top: -UIDevice.STATUS_BAR_HEIGHT, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView!)
    }
    
    func initBackgroundView(){
        //backgroundView
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.frame = CGRect(x: 0, y: 0, width: screenWidth, height:backgroundHeight)
        backgroundView.clipsToBounds = true
        //backgroundView shadow
        backgroundShadowView.frame = backgroundView.frame
        backgroundShadowView.backgroundColor = .black
        backgroundShadowView.alpha = 0.1
        
        
        headerView.addSubview(backgroundView)
        headerView.addSubview(backgroundShadowView)
        
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
        
        headerView.addSubview(avatarShadowView)
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
        headerView.addSubview(stickButton)
    }
    
    func initStickCountLabel(){
        //stickCountLabel
        stickCountLabel.frame = CGRect(x: backgroundView.frame.maxX - stickCountLabelWidth - padding, y: backgroundView.frame.maxY - padding - stickCountLabelHeight, width: stickCountLabelWidth, height: stickCountLabelHeight)
        stickCountLabel.text = profileModel.stickCount
        stickCountLabel.font = .systemFont(ofSize: 12)
        stickCountLabel.textColor = .white
        stickCountLabel.textAlignment = .center
        //stickCountLabel shadow
        stickCountLabel.layer.shadowOpacity = 1
        stickCountLabel.layer.shadowColor = UIColor.black.cgColor
        stickCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        stickCountLabel.layer.shadowRadius = 5
        headerView.addSubview(stickCountLabel)
    }
    
    private func initMoreButton(){
        moreButton.setImage(UIImage(named: "more"), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFill
        moreButton.frame = CGRect(x: backgroundView.frame.maxX - moreButtonWidth - padding, y: UIDevice.STATUS_BAR_HEIGHT + padding, width: moreButtonWidth, height: moreButtonHeight)
        moreButton.backgroundColor = .none
        //stickButton shadow
        moreButton.layer.shadowOpacity = 0.5
        moreButton.layer.shadowColor = UIColor.black.cgColor
        moreButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        moreButton.layer.shadowRadius = 3
        headerView.addSubview(moreButton)
    }
    
    
    func refreshProfileView(){
        let avatarUrlStr:String = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.userDefaults.string(forKey: "socialgroup_id")! + "/profile/avatar/" + profileModel.userDefaults.string(forKey: "user_id")! + "@" + profileModel.avatar + ".jpg"
        avatarView.sd_setImage(with: URL(string: avatarUrlStr), placeholderImage: UIImage(named: "placeholder"), options:[], context: nil)
        avatarView.setNeedsDisplay()
        
        let backgroundUrlStr = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.userDefaults.string(forKey: "socialgroup_id")! + "/profile/background/" + profileModel.userDefaults.string(forKey: "user_id")! + "@" + profileModel.background + ".jpg"
        backgroundView.sd_setImage(with: URL(string: backgroundUrlStr)!, placeholderImage: UIImage(named: "placeholder"), options: [], context: nil)
        backgroundView.setNeedsDisplay()
        
        stickCountLabel.text = profileModel.stickCount
        
        
        tableView?.reloadData()
        view.setNeedsDisplay()
    }
    
    

    //MARK:- tableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailTableViewCell(style: .default, reuseIdentifier: nil)
        cell.setUpUI(profileModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForTableView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            let originalHeight:CGFloat = headerView.frame.height
            
            let scale:CGFloat = (originalHeight - offsetY) / originalHeight
            let transformScale3D:CATransform3D = CATransform3DMakeScale(scale, scale, 1.0)
            let translation3D:CATransform3D = CATransform3DMakeTranslation(0, offsetY/2, 0)
            backgroundShadowView.layer.transform = CATransform3DConcat(transformScale3D, translation3D)
            backgroundView.layer.transform = CATransform3DConcat(transformScale3D, translation3D)
        } else {
            backgroundShadowView.layer.transform = CATransform3DIdentity
            backgroundView.layer.transform = CATransform3DIdentity
        }
    }
    
    
    
    //MARK:- my own profile tapped actions
    @objc func avatarTappedGesture(){
        
    }
    
    @objc func backgroundTappedGesture(){
        
    }
    
    @objc func moreButtonTapped(){
        
    }
    
    @objc func stickButtonTapped(){
        
    }
    
    
}



