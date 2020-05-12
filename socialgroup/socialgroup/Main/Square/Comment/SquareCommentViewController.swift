//
//  SquareCommentViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol SquareCommentViewControllerDelegate:NSObjectProtocol {
    func popDeletedCircleItem(item:CircleItem)
    func popDeletedBroadcastItem(item:BroadcastItem)
}

class SquareCommentViewController: BaseViewController, UINavigationControllerDelegate,  UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate,BroadcastTableViewCellDelegate,BroadcastManagerDelegate,CircleTableViewCellDelegate, CircleManagerDelegate, SquareCommentManagerDelegate, SquareCommentTableViewCellDelegate, SquareJudgeTableViewCellDelegate,SquareReplyManagerDelegate,  WriteViewControllerDelegate  {
    
    //delegate
    var delegate:SquareCommentViewControllerDelegate?
    
    var square_item_id:String!
    var broadcastItem:BroadcastItem!
    var circleItem:CircleItem!
    var square_item_type:String!   //1代表broadcast
    var tableView:UITableView!
    var segment:UISegmentedControl!
    var commentToolbar:UIToolbar!
    var refresher:UIRefreshControl!
    
    // model
    var manager:SquareCommentManager!
    var interactionSegmentIndex:Int = 1
    
    var isInMyBroadcast = false
    
    
    
    let titleScrollHeight:CGFloat = 40.0
    let singleImageViewHeight:CGFloat = UIDevice.SCREEN_WIDTH*2/3
    var lastContentOffset:CGFloat = .zero
    // tableView height calculator
    let cellInitPadding:CGFloat = 10
    let padding:CGFloat = 10
    let titleLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    var collectionViewItemHeight:CGFloat{
        return (UIDevice.SCREEN_WIDTH - padding*2) / 3 - 3
    }
    let interactionSegmentHeight:CGFloat = 30
    let interactionSegmentItemWidth:CGFloat = 200
    let commentCellHeight:CGFloat = 200
    // tableView height calculator
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20
    let commentButtonHeight:CGFloat = 40
    let toolBarHeight:CGFloat = 50
    let moreReplyLabelHeight:CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
//        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        self.title = "详情"
        
        initUI()
        
        // pop Gesture
        let popGesture = self.navigationController!.interactivePopGestureRecognizer
        let popTarget = popGesture?.delegate
        let popView = popGesture!.view!
        popGesture?.isEnabled = false
        
        let popSelector = NSSelectorFromString("handleNavigationTransition:")
        let fullScreenPoGesture = UIPanGestureRecognizer(target: popTarget, action: popSelector)
        fullScreenPoGesture.delegate = self
        
        popView.addGestureRecognizer(fullScreenPoGesture)
    }
    
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
       return true
    }
    

    func initUI(){
        
        // model
        manager = SquareCommentManager()
        manager.delegate = self
        manager.initSquareCommentManager(square_item_type: square_item_type, square_item_id: square_item_id)

        // view
        

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT), style: .plain)
        tableView.contentInset = .init(top: 0, left: 0, bottom: toolBarHeight + padding/2, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        if #available(iOS 13.0, *) {
            tableView.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        
        
        // write comment tool bar
        let commentButton = UIButton(frame: CGRect(x: padding, y: padding/2, width: UIDevice.SCREEN_WIDTH - padding*2, height: commentButtonHeight))
        commentButton.backgroundColor = .systemBlue
        commentButton.setTitle("写评论", for: .normal)
        commentButton.layer.cornerRadius = 5
        commentButton.layer.masksToBounds = true
        commentButton.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
        
        commentToolbar = UIToolbar(frame: CGRect(x: 0, y: UIDevice.SCREEN_HEIGHT - toolBarHeight - UIDevice.HEIGHT_OF_ADDITIONAL_FOOTER, width: UIDevice.SCREEN_WIDTH, height: toolBarHeight))
        commentToolbar.barTintColor = .secondarySystemBackground
        commentToolbar.addSubview(commentButton)
        view.addSubview(commentToolbar)
        

        // refresher
        refresher = UIRefreshControl.init()
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshCommentVC), for: .valueChanged)
        tableView.addSubview(refresher)


        if(NetworkManager.isNetworking()){
            manager.fetchSquareCommentItems()
        }else{
            self.showTempAlert(info: "无法连接网络")
        }
    }
    
    
    // MARK:- calculate Height
    private func calculateHeightForOriginalBroadcast() -> CGFloat{
        let cellWidth = ScreenWidth - 10
        var height = padding + titleLabelHeight + padding + dateLabelHeight + padding + UIDevice.getLabHeigh(labelStr: broadcastItem.content, font: .systemFont(ofSize: contentLabelFontSize), width: cellWidth - padding*2) + padding
        
        let pic_count = broadcastItem.picture_count!
        
        if(pic_count == 0){
            
        }else if(pic_count == 1){
            height += (padding + singleImageViewHeight)
        }else if(pic_count <= 3){
            height += (padding + padding/2 + collectionViewItemHeight)
        }else if(pic_count <= 6){
            height += (padding*2 + collectionViewItemHeight*2)
        }else{
            height += (padding*3 + collectionViewItemHeight*3)
        }
        
        let interactionHeight:CGFloat = 50
        // interaction static
        height += padding + interactionHeight
        
        return height
        
    }
    
    private func calculateHeightForOriginalCircle() -> CGFloat{
        let cellWidth = ScreenWidth
        var height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: circleItem.content, font: .systemFont(ofSize: contentLabelFontSize), width: cellWidth - padding*2) + padding
        
        let pic_count = circleItem.picture_count!

        if(pic_count == 0){

        }else if(pic_count == 1){
            height += (padding + singleImageViewHeight)
        }else if(pic_count <= 3){
            height += (padding + collectionViewItemHeight + padding/2)
        }else if(pic_count <= 6){
            height += (padding*2 + collectionViewItemHeight*2)
        }else{
            height += (padding*3 + collectionViewItemHeight*3)
        }

        let interactionHeight:CGFloat = 50
        // interaction static
        height += padding + interactionHeight
        
        return height
        
    }
    
    
    private func calculateCommentCellHeight(itemIndex: Int) -> CGFloat{
        var height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: manager.squareCommentItems[itemIndex].content, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2) + padding*2
        if(!manager.squareCommentItems[itemIndex].reply_count.equals(str: "0")){
            height = height + moreReplyLabelHeight + padding/2
        }
        
        return height
    }

}


extension SquareCommentViewController{
    
    // MARK:- tableview delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 原square item高度
        if(indexPath.row == 0){
            if(square_item_type.equals(str: "broadcast")){
                return calculateHeightForOriginalBroadcast()
            }else{
                return calculateHeightForOriginalCircle()
            }
        }
    
        //segment 是固定的gaodu
        if(indexPath.row == 1){
            return interactionSegmentHeight + padding
        }
        
        // 点赞或者评论或者疑惑的cell高度
        if(interactionSegmentIndex == 0){
            return avatarImageViewHeight + padding*2
        }else if(interactionSegmentIndex == 1){
            return calculateCommentCellHeight(itemIndex: indexPath.row - 2)
        }else{
            return avatarImageViewHeight + padding*2
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(interactionSegmentIndex == 0){
            return 2 + manager.squareLikeItems.count
        }else if(interactionSegmentIndex == 1){
            return 2 + manager.squareCommentItems.count
        }else{
            return 2 + manager.squareDislikeItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK:- broadcast
        if(square_item_type.equals(str: "broadcast")){
            return initBroadcastTableView(indexPath: indexPath)
        }else{
            return initCircleTableView(indexPath: indexPath)
        }
        
    }
    
    
    private func initBroadcastTableView(indexPath:IndexPath) -> UITableViewCell{
        // broadcast类型
        if(indexPath.row == 0){
            // 原item
            return initOriginalBroadcastItem()
        }else if(indexPath.row == 1){
            // interaction Segment
            return initInteractionSegment()
        }else{
            switch interactionSegmentIndex {
            case 0:
                // 点赞过的人
                let identifier = "broadcastLike" + manager.squareLikeItems[indexPath.row-2].judge_id
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareJudgeTableViewCell
                if(cell == nil){
                    cell = SquareJudgeTableViewCell(style: .default, reuseIdentifier: identifier)
                    cell?.delegate = self
                    cell?.initUI(item: manager.squareLikeItems[indexPath.row-2])
                    cell?.selectionStyle = .none
                }
                return cell!
            case 1:
                // 评论区
                let identifier = "broadcastComment" + manager.squareCommentItems[indexPath.row-2].comment_id
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareCommentTableViewCell
                if(cell == nil){
                    cell = SquareCommentTableViewCell(style: .default, reuseIdentifier: identifier)
                    cell?.delegate = self
                    cell?.initUI(item: manager.squareCommentItems[indexPath.row-2])
                    cell?.selectionStyle = .none
                }else{
                    for view in cell!.subviews{
                        view.removeFromSuperview()
                    }
                    
                    cell?.initUI(item: manager.squareCommentItems[indexPath.row-2])
                }
                return cell!
            case 2:
                // dislike过的人
                let identifier = "broadcastDislike" + manager.squareDislikeItems[indexPath.row-2].judge_id
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareJudgeTableViewCell
                if(cell == nil){
                    cell = SquareJudgeTableViewCell(style: .default, reuseIdentifier: identifier)
                    cell?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200)
                    cell?.delegate = self
                    cell?.initUI(item: manager.squareDislikeItems[indexPath.row-2])
                    cell?.selectionStyle = .none
                }
                return cell!
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    private func initCircleTableView(indexPath:IndexPath) -> UITableViewCell{
        // broadcast类型
        if(indexPath.row == 0){
            // 原item
            return initOriginalCircleItem()
        }else if(indexPath.row == 1){
            // interaction Segment
            return initInteractionSegment()
        }else{
            switch interactionSegmentIndex {
            case 0:
                // 点赞过的人
                let identifier = "circleLike" + manager.squareLikeItems[indexPath.row-2].judge_id
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareJudgeTableViewCell
                if(cell == nil){
                    cell = SquareJudgeTableViewCell(style: .default, reuseIdentifier: identifier)
                    cell?.delegate = self
                    cell?.initUI(item: manager.squareLikeItems[indexPath.row-2])
                    cell?.selectionStyle = .none
                }
                return cell!
            case 1:
                // 评论区
                let identifier = "circleComment" + manager.squareCommentItems[indexPath.row-2].comment_id
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareCommentTableViewCell
                if(cell == nil){
                    cell = SquareCommentTableViewCell(style: .default, reuseIdentifier: identifier)
                    cell?.delegate = self
                    cell?.initUI(item: manager.squareCommentItems[indexPath.row-2])
                    cell?.selectionStyle = .none
                }else{
                    for view in cell!.subviews{
                        view.removeFromSuperview()
                    }
                    
                    cell?.initUI(item: manager.squareCommentItems[indexPath.row-2])
                }
                return cell!
            default:
                break
            }
        }
        return UITableViewCell()

    }
    
    
    // 原broadcastitem
    private func initOriginalBroadcastItem() -> UITableViewCell{
        let identifier = "broadcast" + String(broadcastItem.broadcast_id)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BroadcastTableViewCell
        
        if(cell == nil){
            cell = BroadcastTableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200)
            cell?.delegate = self
            cell?.initUI(item: broadcastItem)
            cell?.selectionStyle = .none
        }else{
            for view in cell!.subviews{
                view.removeFromSuperview()
            }
            
            cell?.initUI(item: broadcastItem)
        }
        return cell!
    }
    
    // 原circleitem
    private func initOriginalCircleItem() -> UITableViewCell{
        let identifier = "circle" + String(circleItem.circle_id)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CircleTableViewCell
        
        if(cell == nil){
            cell = CircleTableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200)
            cell?.delegate = self
            cell?.initUI(item: circleItem)
            cell?.selectionStyle = .none
        }else{
            for view in cell!.subviews{
                view.removeFromSuperview()
            }
            
            cell?.initUI(item: circleItem)
        }
        return cell!
    }
    
    //InteractionSegment
    private func initInteractionSegment() ->UITableViewCell{
        let identifier = "segment" + square_item_type
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if(cell == nil){
            
            if(square_item_type.equals(str: "broadcast")){
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
                cell?.frame = CGRect(x: 0, y: 0, width: interactionSegmentItemWidth * 3, height: interactionSegmentHeight)
                cell?.selectionStyle = .none
                cell?.backgroundColor = .clear
                let tags = ["点赞","评论","疑惑"]
                segment = UISegmentedControl(items: tags)
                segment.frame = CGRect(x: padding, y: padding/2, width: interactionSegmentItemWidth, height: interactionSegmentHeight)
                self.segment?.selectedSegmentIndex = 1
                self.segment?.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
                cell?.addSubview(segment)
            }else if(square_item_type.equals(str: "circle")){
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
                cell?.frame = CGRect(x: 0, y: 0, width: interactionSegmentItemWidth * 3, height: interactionSegmentHeight)
                cell?.selectionStyle = .none
                cell?.backgroundColor = .clear
                let tags = ["点赞","评论"]
                segment = UISegmentedControl(items: tags)
                segment.frame = CGRect(x: padding, y: padding/2, width: interactionSegmentItemWidth, height: interactionSegmentHeight)
                self.segment?.selectedSegmentIndex = 1
                self.segment?.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
                cell?.addSubview(segment)
            }else{
                print("no such interaction segment")
            }
        }
        return cell!
    }
    
    
    
    
    
    // MARK:- @objc functions
    @objc func segmentDidChange(_ sender: UISegmentedControl){
        self.interactionSegmentIndex = sender.selectedSegmentIndex
        if(interactionSegmentIndex == 0){
            manager.fetchSquareLikeItems()
        }else if(interactionSegmentIndex == 2){
            manager.fetchSquareDislikeItems()
        }else{
            manager.fetchSquareCommentItems()
        }
        self.tableView.reloadData()
        print(sender.selectedSegmentIndex)
    }
    
    @objc func writeComment(){
        print("write comment")
        let writeCommentVC = WriteViewController()
        writeCommentVC.initCommentTextView(limit: 200)
        writeCommentVC.delegate = self
        let nc = UINavigationController(rootViewController: writeCommentVC)
        self.present(nc, animated: true, completion: nil)
        
    }
    
    @objc func refreshCommentVC(){
        if(interactionSegmentIndex == 0){
            manager.fetchSquareLikeItems()
        }else if(interactionSegmentIndex == 2){
            manager.fetchSquareDislikeItems()
        }else{
            manager.fetchSquareCommentItems()
        }
        print("refresh")
    }
    
    
    
    // MARK:- original broadcast cell delegate
    // 点赞 评论 问号 更多四个图标的代理方法
    func likeButtonTappedBroadcast(item: BroadcastItem) {
        let broadcastManager = BroadcastManager()
        broadcastManager.delegate = self
        if(item.isLiked){
            let alert = UIAlertController(title: "提示", message: "您已点赞过，是否取消点赞？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                broadcastManager.likeItem(item: item, isToCancel: true)
                
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            broadcastManager.likeItem(item: item, isToCancel: false)
        }
    }
    
    func commentButtonTappedBroadcast(item: BroadcastItem) {
        writeComment()
    }
    
    func dislikeButtonTappedBroadcast(item: BroadcastItem) {
        let broadcastManager = BroadcastManager()
        broadcastManager.delegate = self
        if(item.isDisliked){
            let alert = UIAlertController(title: "提示", message: "您已表示疑惑过，是否取消表示疑惑？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                broadcastManager.dislikeItem(item: item, isToCancel: true)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            broadcastManager.dislikeItem(item: item, isToCancel: false)
        }
    }
    
    func moreButtonTappedBroadcast(item: BroadcastItem) {
        let broadcastManager = BroadcastManager()
        broadcastManager.delegate = self
        let pushTappedSheet = UIAlertController.init(title: "更多", message: nil, preferredStyle: .actionSheet)
        self.present(pushTappedSheet, animated: true, completion: nil)
        pushTappedSheet.addAction(.init(title: "举报该条广播", style: .default, handler:{(action: UIAlertAction) in
            broadcastManager.reportItem(item: item)
        } ))
        if(isInMyBroadcast){
            pushTappedSheet.addAction(.init(title: "删除该条广播", style: .default, handler:{(action: UIAlertAction) in
                broadcastManager.deleteItem(item: item)
            } ))
        }
        pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
    }
    
    
    // MARK:- comment cell delegate
    func avatarTappedComment(item: SquareCommentItem) {
        print("avatar tapped")
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: Int(item.user_id)!)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
    }
    
    func seeMoreReply(item: SquareCommentItem) {
        print("see more reply tapped")
        let replyVC = SquareReplyViewController()
        replyVC.initData(commentItem: item)
        self.navigationController?.pushViewController(replyVC, animated: true)
    }
    
    func replyToComment(item:SquareCommentItem){
        let writeReplyVC = WriteViewController()
        writeReplyVC.initReplyToCommentTextView(limit: 200, squareCommentItem: item)
        writeReplyVC.delegate = self
        let nc = UINavigationController(rootViewController: writeReplyVC)
        self.present(nc, animated: true, completion: nil)
    }
    
    // MARK: - judge cell delegate
    func SquareJudgeTableViewCellAvatarTapped(item: SquareJudgeItem) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: Int(item.user_id)!)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
        print("avatar tapped")
    }
    
    // MARK:- SquareCommentManager delegate
    func fetchSquareCommentItemsSuccess() {
        tableView.reloadData()
        self.refresher.endRefreshing()
        print("fetch success")
    }
    
    func fetchSquareCommentItemsFail() {
        print("fetchFail")
        self.showTempAlert(info: "fetch fail")
    }
    
    func fetchSquareLikeItemsSuccess() {
        tableView.reloadData()
        self.refresher.endRefreshing()
        print("fetch success")
    }
    
    func fetchSquareLikeItemsFail() {
        print("fetch fail")
        self.showTempAlert(info: "fetch fail")
    }
    
    func fetchSquareDislikeItemsSuccess() {
        tableView.reloadData()
        self.refresher.endRefreshing()
        print("fetch success")
    }
    
    func fetchSquareDislikeItemsFail() {
        print("fetch fail")
        self.showTempAlert(info: "fetch fail")
    }
    
    func pushCommentSuccess() {
        manager.fetchSquareCommentItems()
        self.showTempAlert(info: "评论成功")
    }
    
    func pushCommentFail() {
        self.showTempAlert(info: "评论失败")
    }
    
    //MARK:- Square reply manager delegate
    func fetchSquareReplySuccess() {
        print("fetch reply success in squareCommentViewCOntroller")
        // no need
    }
    
    func fetchSquareReplyFail() {
        print("fetch push reply fail in squareCommentViewcontroller")
        self.showTempAlert(info: "fetch fail")
        // no need
    }
    
    func pushReplySuccess() {
        manager.fetchSquareCommentItems()
        self.showTempAlert(info: "回复成功")
        
    }
    
    func pushReplyFail() {
        self.showTempAlert(info: "回复失败")
        
    }
    
    
    //MARK:- WriteViewController Delegate
    func pushComment(content: String) {
        manager.pushComment(content: content)
    }
    
    func pushReplyToComment(content: String, item: SquareCommentItem) {
        let replyManager = SquareReplyManager()
        replyManager.initSquareReplyManger(squareCommentItem: item)
        replyManager.pushReplyToComment(content: content)
        replyManager.delegate = self
        print("push reply in SquareCommentViewController")
    }
    
    func pushReplyToReply(content: String, item: SquareReplyItem) {
        print("push reply to reply in SquareCommentViewController")
        // no need
    }
    
    
    
    
}





extension SquareCommentViewController{
    // MARK:- BroadcastManager delegate
    func BroadcastFetchSuccess(result: String, info: String) {
        // no need
    }
    
    func BroadcastFetchFail(result: String, info: String) {
        // no need
    }
    
    func likeItemSuccess(item:BroadcastItem, isToCancel: Bool) {
        print("likeItem succuess")
        if(isToCancel){
            broadcastItem.isLiked = false
            broadcastItem.like_count -= 1
        }else{
            broadcastItem.isLiked = true
            broadcastItem.like_count += 1
        }
        tableView.reloadData()
    }
    
    func likeItemFail(result: String, info: String, isToCancel: Bool) {
        print("likeItem FAil maybe istocancel??")
    }
    
    func dislikeItemFail(result: String, info: String, isToCancel: Bool) {
        print("dislikeItem FAil maybe istocancel??")
    }
    
    func dislikeItemSuccess(item:BroadcastItem, isToCancel: Bool) {
        print("dislikeItem succuess")
        if(isToCancel){
            broadcastItem.isDisliked = false
            broadcastItem.dislike_count -= 1
        }else{
            broadcastItem.isDisliked = true
            broadcastItem.dislike_count += 1
        }
        tableView.reloadData()
    }
    
    func reportItemSuccess(item: BroadcastItem) {
        self.showTempAlert(info: "举报成功")
    }
    
    func reportItemFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "举报失败，可能因为您已经举报过了")
    }
    
    
    
    
    // MARK:- circle delegate
    
    func avatarTappedCircle(item: CircleItem) {
        self.showOtherProfile(userId: item.user_id)
    }
    
    func likeButtonTappedCircle(item: CircleItem) {
        let circleManager = CircleManager()
        circleManager.delegate = self
        if(item.isLiked){
            let alert = UIAlertController(title: "提示", message: "您已点赞过，是否取消点赞？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                circleManager.likeItem(item: item, isToCancel: true)
                
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            circleManager.likeItem(item: item, isToCancel: false)
        }
    }
    
    func commentButtonTappedCircle(item: CircleItem) {
        writeComment()
    }
    
    func moreButtonTappedCircle(item: CircleItem) {
        let circleManager = CircleManager()
        circleManager.delegate = self
        let pushTappedSheet = UIAlertController.init(title: "更多", message: nil, preferredStyle: .actionSheet)
        self.present(pushTappedSheet, animated: true, completion: nil)
        pushTappedSheet.addAction(.init(title: "举报该条广播", style: .default, handler:{(action: UIAlertAction) in
            circleManager.reportItem(item: item)
        } ))
        pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
        if(item.user_id == Int(UserDefaultsManager.getUserId())){
            // 说明是我自己发的内容
            pushTappedSheet.addAction(.init(title: "删除我的动态", style: .default, handler:{(action: UIAlertAction) in
                circleManager.deleteItem(item: item)
            } ))
        }
    }
    
    func CircleFetchSuccess(result: String, info: String) {
        // no need
    }
    
    func CircleFetchFail(result: String, info: String) {
        // no need
    }
    
    func likeItemSuccess(item: CircleItem, isToCancel: Bool) {
        print("likeItem succuess")
        if(isToCancel){
            item.isLiked = false
            item.like_count -= 1
        }else{
            item.isLiked = true
            item.like_count += 1
        }
        tableView.reloadData()
    }
    
    func reportItemSuccess(item: CircleItem) {
        self.showTempAlert(info: "举报成功")
    }
    
    func deleteItemSuccess(item: BroadcastItem) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.popDeletedBroadcastItem(item: item)
    }
    
    func deleteItemSuccess(item: CircleItem) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.popDeletedCircleItem(item: item)
        
    }
    
    func deleteItemFail(result: String, info: String) {
        self.showTempAlert(info: "删除失败，出bug了")
    }
    
}

