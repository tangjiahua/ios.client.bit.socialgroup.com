//
//  PosterDetailViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/3/1.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class PosterDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //view
    var tableView:UITableView!
    var bgImageView:UIImageView!
    @objc var headerView:UIView!
    var titleLabel:UILabel!
    var posterImageView:UIImageView!
    var bgImage:UIImage?
    
    //model
    var model:PosterModel!
    
    // cgfloat
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    let ScreenHeight = UIDevice.SCREEN_HEIGHT
    let wallPosterRatio:CGFloat = 1.2
    let padding:CGFloat = 10
    let headerImageViewRatio:CGFloat = 1.2
    //控件属性
    let staticLabelHeight:CGFloat = 25
    let staticLabelFontSize:CGFloat = 25
    let infoLabelFontSize:CGFloat = 17
    let briefLabelHeight:CGFloat = 35
    let briefLabelWidth:CGFloat = 300
    let briefFontSize:CGFloat = 80

    //gesture handler need
    var cellHeight:CGFloat?
    var startPointX:CGFloat = 0
    var startPointY:CGFloat = 0
    var scale:CGFloat = 1
    var isHorizontal:Bool = false
    var selectIndexPath:IndexPath!
    
    
    

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        initUI()
        
        
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.delegate = self
    }
    
    private func initUI(){
        view.backgroundColor = .tertiarySystemBackground
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 上一个视图的背景
        bgImageView.frame = view.bounds
        view.addSubview(bgImageView)
        
        // 模糊
        let effect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        view.addSubview(effectView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIDe, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .tertiarySystemBackground
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = initHeaderView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "posterdetailidentifier")
        
        view.addSubview(tableView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        
        scale = 1
        
        
    }
    

    
    //MARK: headerView
    private func initHeaderView() ->UIView{
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*headerImageViewRatio))
        
        
        let posterUrlStr = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/wall/poster/" + model.notification_id + ".jpg"

        posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*headerImageViewRatio))
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        posterImageView.sd_setImage(with: URL(string: posterUrlStr), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached], context: nil)
//        headerImageView.sd_setImage(with: URL(string: posterUrlStr), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .avoidAutoSetImage], context: nil, progress: nil) { (image, error, cacheType, imageURL) in
//            // 裁减图片
//            let coppedImage = image?.sd_croppedImage(with: CGRect(x: 0, y: 0, width: self.ScreenWidth, height: self.ScreenWidth*self.wallPosterRatio))
//
//            DispatchQueue.main.async {
//                self.headerImageView.image = coppedImage
//                self.headerImageView.setNeedsLayout()
//            }
//        }

        titleLabel = UILabel(frame: CGRect(x: padding, y: ScreenWidth * headerImageViewRatio - briefLabelHeight - padding, width: briefLabelWidth  , height: briefLabelHeight))
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: briefFontSize)
        titleLabel.text = model.brief
        
        headerView.addSubview(posterImageView)
        headerView.addSubview(titleLabel)

        return headerView
    }
    

}


extension PosterDetailViewController{
    // MARK:-  tableview delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = padding + UIDevice.getLabHeigh(labelStr: model.welcome, font: .systemFont(ofSize: staticLabelFontSize), width: ScreenWidth-padding*2) + padding + staticLabelHeight*3 + padding*3
        height += UIDevice.getLabHeigh(labelStr: model.holddate, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)// hold date
        height += UIDevice.getLabHeigh(labelStr: model.holdlocation, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)// hold location
        height += UIDevice.getLabHeigh(labelStr: model.holder, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)// holder
        height += padding*3 // dynamic label padding
        
        height += UIDevice.getLabHeigh(labelStr: model.detail, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)// detail
        height += padding + staticLabelHeight + padding // link button
        
        
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "posterdetail" + model.notification_id + "identifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell = initPosterDetailCell(identifier: identifier)
            
            return cell!
            
        }

        return cell!
    }
    
    private func initPosterDetailCell(identifier:String) -> UITableViewCell{
        //控件属性
        
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.selectionStyle = .none
        cell.backgroundColor = .tertiarySystemBackground
        
        //welcome
        
        let welcomeLabel = UILabel(frame: CGRect(x: padding, y: padding, width: ScreenWidth-padding*2, height: UIDevice.getLabHeigh(labelStr: model.welcome, font: .systemFont(ofSize: 17), width: ScreenWidth - padding*2)))
        welcomeLabel.textColor = .secondaryLabel
        welcomeLabel.text = model.welcome
        welcomeLabel.numberOfLines = 0
        cell.addSubview(welcomeLabel)
        
        
        
        //时间：
        let dateLabel = UILabel(frame: CGRect(x: padding, y: welcomeLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight))
        dateLabel.font = .boldSystemFont(ofSize: staticLabelFontSize)
        dateLabel.textColor = .label
        dateLabel.text = "时间："
        cell.addSubview(dateLabel)
        
        //holddate
        let holddateLabel = UILabel(frame: CGRect(x: padding, y: dateLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: UIDevice.getLabHeigh(labelStr: model.holddate, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)))
        holddateLabel.textColor = .secondaryLabel
        holddateLabel.text = model.holddate
        holddateLabel.numberOfLines = 0
        cell.addSubview(holddateLabel)
        
        
        
        //地点：
        let locationLabel = UILabel(frame: CGRect(x: padding, y: holddateLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight))
        locationLabel.font = .boldSystemFont(ofSize: staticLabelFontSize)
        locationLabel.textColor = .label
        locationLabel.text = "地点："
        cell.addSubview(locationLabel)
        
        
        //holdlocation
        
        let holdLocationLabel = UILabel(frame: CGRect(x: padding, y: locationLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: UIDevice.getLabHeigh(labelStr: model.holdlocation, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)))
        holdLocationLabel.textColor = .secondaryLabel
        holdLocationLabel.numberOfLines = 0
        holdLocationLabel.text = model.holdlocation
        cell.addSubview(holdLocationLabel)
        
        
        //举办者：
        let staticHolderLabel = UILabel(frame: CGRect(x: padding, y: holdLocationLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight))
        staticHolderLabel.font = .boldSystemFont(ofSize: staticLabelFontSize)
        staticHolderLabel.textColor = .label
        staticHolderLabel.text = "举办者："
        cell.addSubview(staticHolderLabel)
        
        
        //holder
        let holderLabel = UILabel(frame: CGRect(x: padding, y: staticHolderLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: UIDevice.getLabHeigh(labelStr: model.holder, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth-padding*2)))
        holderLabel.textColor = .secondaryLabel
        holderLabel.numberOfLines = 0
        holderLabel.text = model.holder
        cell.addSubview(holderLabel)
        
        //detail
        
        let detailLabel = UILabel(frame: CGRect(x: padding, y: holderLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: UIDevice.getLabHeigh(labelStr: model.detail, font: .systemFont(ofSize: infoLabelFontSize), width: ScreenWidth - padding*2)))
        detailLabel.font = .systemFont(ofSize: infoLabelFontSize)
        detailLabel.textColor = .secondaryLabel
        detailLabel.text = model.detail
        detailLabel.numberOfLines = 0
        cell.addSubview(detailLabel)
        
        
        
        //more
        let linkLabel = UILabel(frame: CGRect(x: padding, y: detailLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight))
        linkLabel.text = "更多详情"
        linkLabel.textColor = .systemBlue
        linkLabel.font = .systemFont(ofSize: infoLabelFontSize)
        linkLabel.textAlignment = .right
        linkLabel.isUserInteractionEnabled = true
        let linkLabelTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkLabelTapped))
        linkLabel.addGestureRecognizer(linkLabelTappedGestureRecognizer)
        
        cell.addSubview(linkLabel)
        
        
        return cell
    }
    
    @objc func linkLabelTapped(){
        UIApplication.shared.open(URL(string: model.link)!, options: [:], completionHandler: nil)
    }
}


extension PosterDetailViewController{
    // MARK:- gesture handler
    @objc func handleGesture(_ sender:UIGestureRecognizer){
        weak var weakSelf = self
        switch sender.state {
        case .began:
            print("手势开始---")
            let currentPoint = sender.location(in: tableView)
            startPointX = currentPoint.x
//            isHorizontal = (startPointX > CGFloat(200)) ? false : true
            isHorizontal = true
            break
        case .changed:
            print("拖动中----")
            let currentPoint = sender.location(in: tableView)
            if isHorizontal {
                if ((currentPoint.x-startPointX)>0) {
                    scale = (ScreenWidth-(currentPoint.x-startPointX))/ScreenWidth
                }
            }

            if (scale > CGFloat(1)) {
                scale = CGFloat(1)
            } else if (scale <= CGFloat(0.7)) {
                DispatchQueue.main.async {
                    weakSelf?.navigationController?.popViewController(animated: true)
                }
            }
            // 缩放
//            tableView.contentInset.top = 0
            tableView.transform = CGAffineTransform(scaleX: scale, y: scale)
            // 圆角
            tableView.layer.cornerRadius = 15

            tableView.isScrollEnabled = (scale < 0.99) ? false : true
            break
        case .ended:
            print("手势结束--")
            tableView.isScrollEnabled = true
            if scale > CGFloat(0.7) {
                UIView.animate(withDuration: 0.2) {
                    weakSelf?.tableView.layer.cornerRadius = 0
                    weakSelf?.tableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
//                tableView.contentInset.top = -UIDevice.STATUS_BAR_HEIGHT
                scale = 1
            }
            break
        default:
            break
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (scrollView.contentOffset.y <= 0) {
//            print(scrollView.contentOffset.y)
//            var rectQ:CGRect = self.headerImageView!.frame
//            rectQ.origin.y = scrollView.contentOffset.y
//            self.headerImageView!.frame = rectQ
//        }
        
        let offsetY = scrollView.contentOffset.y
        print(offsetY)
        if offsetY < 0 {
//            let originalHeight:CGFloat = headerImageView.frame.height
            let originalHeight:CGFloat = headerView.frame.height
            
            let scale:CGFloat = (originalHeight - offsetY) / originalHeight
            let transformScale3D:CATransform3D = CATransform3DMakeScale(scale, scale, 1.0)
            let translation3D:CATransform3D = CATransform3DMakeTranslation(0, offsetY/2, 0)
            posterImageView.layer.transform = CATransform3DConcat(transformScale3D, translation3D)
            
            
        } else {
            posterImageView.layer.transform = CATransform3DIdentity
        }
    }

    
    
    
    
    
}


// MARK:- view controller transitioning customized
extension PosterDetailViewController: UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        return self
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC:WallViewController = transitionContext.viewController(forKey: .to) as! WallViewController
        let fromVC:PosterDetailViewController = transitionContext.viewController(forKey: .from) as! PosterDetailViewController
        let containerView = transitionContext.containerView

        let fromView:UIView = fromVC.value(forKeyPath: "headerView") as! UIView
//        let titleLabel
//        toVC.view.frame = transitionContext.finalFrame(for: toVC)

        let cell:PosterCell = toVC.tableView.cellForRow(at: selectIndexPath!) as! PosterCell
        let originView = cell.bgView

        let snapShotView = fromView.snapshotView(afterScreenUpdates: false)
        snapShotView?.layer.masksToBounds = true
        snapShotView?.layer.cornerRadius = 15
        snapShotView?.contentMode = .scaleAspectFill
        snapShotView?.backgroundColor = .clear
        snapShotView?.frame = containerView.convert(fromView.frame, from: fromView.superview)
        fromView.isHidden = true
        originView?.alpha = 0


//        let titleLabel = UILabel()
//        titleLabel.frame = snapShotView!.convert(self.titleLabel.frame, from: fromView)
//        titleLabel.textColor = UIColor.white
//        titleLabel.font = UIFont.boldSystemFont(ofSize: briefFontSize)
//        titleLabel.numberOfLines = 0
//        titleLabel.adjustsFontSizeToFitWidth = true
//        titleLabel.text = model.brief


//        snapShotView?.addSubview(titleLabel)

//        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        toVC.view.alpha = 0

        containerView.addSubview(toVC.view)

        containerView.addSubview(snapShotView!)
        
        
    

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            containerView.layoutIfNeeded()
            fromVC.view.alpha = 0
            toVC.view.alpha = 1
            snapShotView?.frame = containerView.convert((originView?.frame)!, from: originView?.superview)




        }) { (finished) in
            fromView.isHidden = true
            snapShotView?.removeFromSuperview()
            originView?.alpha = 1
            transitionContext.completeTransition(true)
        }

    }
    
    
}
