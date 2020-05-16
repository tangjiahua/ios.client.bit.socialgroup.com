//
//  WallViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/10.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class WallViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, WallManagerDelegate, PosterPushViewControllerDelegate {
    
    
    
    var manager:WallManager!
    var userDefaultsManager = UserDefaultsManager()
    
    
    var tableView:UITableView!
    var selectIndexPath:IndexPath?
    var refresher:UIRefreshControl!
    var pushBarButtonItem:UIBarButtonItem?
    
    //cgfloat
    let ScreenWidth:CGFloat = UIDevice.SCREEN_WIDTH
    let ScreenHeight:CGFloat = UIDevice.SCREEN_HEIGHT
    let wallAvatarWidth:CGFloat = 40
//    let wallPadding:CGFloat = 20
//    let wallPushDateHeight:CGFloat = 12
//    let wallMediumPadding:CGFloat = 10
//    let wallSmallerPadding:CGFloat = 5
    let wallPosterRatio:CGFloat = 1.2
    let publisherHeight:CGFloat = 25
    let padding:CGFloat = 10
    let briefFontSize:CGFloat = 80
    let briefLabelHeight:CGFloat = 35
    let briefLabelWidth:CGFloat = 300
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        self.title = "公告墙"
        
        // Do any additional setup after loading the view.
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.delegate = self
        if(self.navigationController!.viewControllers.count <= 1){
            tabBarController?.hideTabbar(hidden: false)
        }
    }
    
    private func initUI(){
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WallTableViewCell")
        
        view.addSubview(tableView)
        
        
        // push button
        
        if(UserDefaultsManager.getRole().equals(str: "1")){
            pushBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(pushClick))
            pushBarButtonItem?.tintColor = UIColor.label
            self.navigationItem.rightBarButtonItem = pushBarButtonItem!
        }

        //refreshControler
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        self.refresher!.addTarget(self, action: #selector(refreshLatestWall), for: .valueChanged)
        
    }
    
    private func initData(){
        manager = WallManager()
        manager.delegate = self
        manager.fetchNewWall()
        
    }
    
    @objc func refreshLatestWall(){
        manager.fetchNewWall()
    }


}


extension WallViewController{
    // MARK:- Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.posterModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "wallCell" + manager.posterModels[indexPath.row].notification_id
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            if(manager.posterModels[indexPath.row].type == "1"){
                
                let cell = PosterCell(style: .default, reuseIdentifier: identifier)
                cell.selectionStyle = .none
                cell.shouldGroupAccessibilityChildren = true
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                cell.setValueForCell(model: manager.posterModels[indexPath.row])
                return cell
                
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculatePosterCellHeight(row: indexPath.row)
    }
    
    private func calculatePosterCellHeight(row: Int)->CGFloat{
//        return wallMediumPadding + wallAvatarWidth +  wallSmallerPadding + wallSmallerPadding + (ScreenWidth-wallPadding*2) * wallPosterRatio + wallPushDateHeight + wallSmallerPadding*2 + wallMediumPadding
        return padding + wallAvatarWidth + padding + (ScreenWidth - padding*2)*wallPosterRatio + padding
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  posterDetailVC = PosterDetailViewController()
        posterDetailVC.model = manager.posterModels[indexPath.row]
        posterDetailVC.selectIndexPath = indexPath
        posterDetailVC.bgImageView = UIImageView()
        posterDetailVC.bgImageView.image = view.asImage()
        
        
        let cell = tableView.cellForRow(at: indexPath)

        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform.init(scaleX: 0.98, y: 0.98)
        }) { (result) in
            UIView.animate(withDuration: 0.1) {
                cell?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                if(self.navigationController?.viewControllers.count == 1){
                    self.tabBarController?.hideTabbar(hidden: true)
                }
                self.navigationController?.pushViewController(posterDetailVC, animated: true)
            }
        }
    }
    
    //点击cell变小
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath) as! PosterCell
        selectIndexPath = indexPath
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
        return true
    }
    
    //松开cell恢复正常
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PosterCell
        if selectIndexPath == indexPath{
            UIView.animate(withDuration: 0.3) {
                cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                return
            }
        }
        
    }
}


// MARK:- Animation
extension WallViewController: UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let cell:PosterCell = tableView.cellForRow(at: selectIndexPath!) as! PosterCell
        let toVC:UIViewController = transitionContext.viewController(forKey: .to)!
        let toView:UIView = toVC.value(forKeyPath:"headerView") as! UIView
        let fromView = cell.bgView
        
        let containerView = transitionContext.containerView
        
        let snapshotView = UIImageView(image: cell.bgImageView!.image)
        snapshotView.frame = containerView.convert((fromView?.frame)!, from: fromView?.superview)
        snapshotView.layer.masksToBounds = true
//        snapshotView.layer.cornerRadius = 15
        snapshotView.contentMode = .scaleAspectFill
        
        
        fromView?.alpha = 0
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0
        toView.alpha = 0
        
//        let titleLabel = UILabel(frame: CGRect(x: 15, y: (ScreenWidth-wallPadding*2)*wallPosterRatio - 35 * 2 - 20, width: ScreenWidth-30 - wallPadding*2, height: 35 * 2))
//        let titleLabel = UILabel(frame: CGRect(x: padding, y: snapshotView.bounds.height - padding - briefLabelHeight, width: snapshotView.bounds.width - padding*2, height: briefLabelHeight))
        let titleLabel = UILabel()
        titleLabel.frame = snapshotView.convert(cell.titleLabel.frame, from: cell.titleLabel.superview)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: briefFontSize)
        titleLabel.text = cell.titleLabel?.text
        
        
        snapshotView.addSubview(titleLabel)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshotView)
        
        UIView.animate(withDuration: 0.2, animations: {
            
            toVC.navigationController!.navigationBar.frame = toVC.navigationController!.navigationBar.frame.offsetBy(dx: 0, dy: -toVC.navigationController!.navigationBar.frame.height - UIDevice.STATUS_BAR_HEIGHT)
        })
        
        
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
//                    containerView.layoutIfNeeded()
                    toVC.view.alpha = 1.0
//            self.view.frame = CGRect(x: 0, y: 0, width: self.ScreenWidth, height: self.ScreenHeight)
                    snapshotView.frame = containerView.convert(toView.frame, from: toView.superview)
            
//            titleLabel.frame =  CGRect(x: 22, y: self.ScreenWidth*self.wallPosterRatio - 35 * 2 + 20, width: self.ScreenWidth-44, height: 35*2)
            
            titleLabel.frame = CGRect(x: self.padding, y: self.ScreenWidth*self.wallPosterRatio - self.padding - self.briefLabelHeight, width: self.briefLabelWidth, height: self.briefLabelHeight)
//            titleLabel.font = UIFont.boldSystemFont(ofSize: self.briefFontSize)
            
                }) { (finished) in
        
                    
                    toView.alpha = 1
                    fromView?.alpha = 1
                    snapshotView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
        
    }

    
    
}


extension WallViewController{
    // MARK:- wall manager delegate
    func fetchNewWallSuccess() {
        tableView.reloadData()
        refresher.endRefreshing()
        print("fetch success")
    }
    
    func fetchNewWallFail() {
        print("fetch fail")
    }
    
    func fetchOldWallSuccess() {
        tableView.reloadData()
        print("fetch success")
    }
    
    func fetchOldWallFail() {
        print("fetch fail")
    }
}


extension WallViewController{
    // push
    // external settings
    @objc func pushClick(){
        
        print("pushCLicked")
        let pushClickSheet = UIAlertController.init(title: "选择发布类型", message: nil, preferredStyle: .actionSheet)
        self.present(pushClickSheet, animated: true)
        pushClickSheet.addAction(.init(title: "上传海报", style: .default, handler: { (UIAlertAction) in
            let pushPosterVC = PosterPushViewController()
            pushPosterVC.modalPresentationStyle = .fullScreen
            pushPosterVC.setUpViews()
            pushPosterVC.delegate = self
            pushPosterVC.push_api = NetworkManager.WALL_PUSH_API
            self.present(pushPosterVC, animated: true, completion: nil)
        }))
        pushClickSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
        
    }
    
    func posterPushSuccess() {
        self.showTempAlert(info: "发布海报成功")
        self.refreshLatestWall()
    }
}
