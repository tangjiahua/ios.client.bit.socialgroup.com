//
//  BroadcastViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/21.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit



class MyBroadcastViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, BroadcastManagerDelegate, BroadcastTableViewCellDelegate, SquareCommentViewControllerDelegate, UIGestureRecognizerDelegate{
    
    
    
    //manager
    var manager:BroadcastManager!
    
    //view
    var tableView:UITableView!
    var refresher:UIRefreshControl!
    
    //delegate
    var delegate:BroadcastViewControllerDelegate?
    
    //ui
    let titleScrollHeight:CGFloat = 40.0
    let singleImageViewHeight:CGFloat = UIDevice.SCREEN_WIDTH*2/3
    var lastContentOffset:CGFloat = .zero
    let cellInitPadding:CGFloat = 10
    let padding:CGFloat = 10
    let titleLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    var collectionViewItemHeight:CGFloat{
        return (UIDevice.SCREEN_WIDTH - padding*2) / 3 - 3
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // model
        manager = BroadcastManager()
        manager.delegate = self
        
        // view
        view.backgroundColor = .secondarySystemBackground
        self.title = "我发布的广播"
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(BroadcastTableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        // refresher
        refresher = UIRefreshControl.init()
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshBroadcast), for: .valueChanged)
        tableView.addSubview(refresher)
        
        
        if(NetworkManager.isNetworking()){
            manager.fetchMyNewBroadcastItems()
        }else{
            self.showTempAlert(info: "无法连接网络")
        }
        
//
//        // pop Gesture
//        let popGesture = self.navigationController!.interactivePopGestureRecognizer
//        let popTarget = popGesture?.delegate
//        let popView = popGesture!.view!
//        popGesture?.isEnabled = false
//
//        let popSelector = NSSelectorFromString("handleNavigationTransition:")
//        let fullScreenPoGesture = UIPanGestureRecognizer(target: popTarget, action: popSelector)
//        fullScreenPoGesture.delegate = self
//
//        popView.addGestureRecognizer(fullScreenPoGesture)
    }
    
//    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//       return true
//    }
    
    
    // MARK:- Refresher
    @objc func refreshBroadcast(){
        manager.fetchMyNewBroadcastItems()
    }
    

}

extension MyBroadcastViewController{
    
    // MARK:- Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.broadcastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier" + String(manager.broadcastItems[indexPath.row].broadcast_id)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BroadcastTableViewCell
        
        if(cell == nil){
            cell = BroadcastTableViewCell(style: .default, reuseIdentifier: "identifier" + String(manager.broadcastItems[indexPath.row].broadcast_id))
            cell?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200)
            cell?.delegate = self
            cell?.initUI(item: manager.broadcastItems[indexPath.row])
            cell?.selectionStyle = .none
            // calculate height for row
        }else{
            for view in cell!.subviews{
                view.removeFromSuperview()
            }
            cell?.initUI(item: manager.broadcastItems[indexPath.row])
        }
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeightForRow(row: indexPath.row)
    }
    
    // MARK:- 进入评论区
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showCommentVC(item: manager.broadcastItems[indexPath.row])
    }
    
    private func showCommentVC(item: BroadcastItem){
        let commentVC = SquareCommentViewController()
        commentVC.broadcastItem = item
        commentVC.square_item_type = "broadcast"
        commentVC.square_item_id = String(item.broadcast_id)
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func calculateHeightForRow(row: Int) -> CGFloat{
        let cellWidth = ScreenWidth - 10
        var height = padding + titleLabelHeight + padding + dateLabelHeight + padding + UIDevice.getLabHeigh(labelStr: manager.broadcastItems[row].content, font: .systemFont(ofSize: contentLabelFontSize), width: cellWidth - padding*2) + padding
        
        let pic_count = manager.broadcastItems[row].picture_count!
        
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
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if(scrollView.contentOffset.y <= -TitleHeight){
//            self.delegate?.showTitleScrollView()
//            return
//        }else{
//            self.delegate?.hideTitleScrollView()
//        }
//
////        if (self.lastContentOffset < scrollView.contentOffset.y || (self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y > -TitleHeight)) {
////            // 向上滚动
////            self.delegate?.hideTitleScrollView()
////        }
//
//
//        self.lastContentOffset = scrollView.contentOffset.y;
//
//    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        self.delegate?.showTitleScrollView()
        return true
    }
    
    
    // 滑到底部的时候加载更多的旧item
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == manager.broadcastItems.count - 1){
            manager.fetchMyOldBroadcastItems()
        }
    }
    
    
    // MARK:- BroadcastManager Delegate
    func BroadcastFetchSuccess(result: String, info: String) {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func BroadcastFetchFail(result: String, info: String) {
        print("no more")
    }
    
    func likeItemSuccess(item:BroadcastItem, isToCancel: Bool) {
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
    
    func likeItemFail(result: String, info: String, isToCancel: Bool) {
        print("likeItem FAil maybe istocancel??")
    }
    
    func dislikeItemFail(result: String, info: String, isToCancel: Bool) {
        print("dislikeItem FAil maybe istocancel??")
    }
    
    func dislikeItemSuccess(item:BroadcastItem, isToCancel: Bool) {
        print("dislikeItem succuess")
        if(isToCancel){
            item.isDisliked = false
            item.dislike_count -= 1
        }else{
            item.isDisliked = true
            item.dislike_count += 1
        }
        tableView.reloadData()
    }
    
    func reportItemSuccess(item: BroadcastItem) {
        self.showTempAlert(info: "举报成功")
    }
    
    func reportItemFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "举报失败，可能因为您已经举报过了")
    }
    
    
    
    
    // MARK:- Broadcast Cell delegate
    
    func collectionSpaceTapped(item: BroadcastItem) {
        showCommentVC(item: item)
    }
    
    func likeButtonTappedBroadcast(item: BroadcastItem) {
        if(item.isLiked){
            let alert = UIAlertController(title: "提示", message: "您已点赞过，是否取消点赞？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                self.manager.likeItem(item: item, isToCancel: true)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            self.manager.likeItem(item: item, isToCancel: false)
        }
    }
    
    func commentButtonTappedBroadcast(item: BroadcastItem) {
        print("commentr")
        let commentVC = SquareCommentViewController()
        commentVC.broadcastItem = item
        commentVC.square_item_type = "broadcast"
        commentVC.square_item_id = String(item.broadcast_id)
        commentVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(commentVC, animated: true)
        
        if(item.comment_count == 0){
            commentVC.writeComment()
        }
    }
    
    func dislikeButtonTappedBroadcast(item: BroadcastItem) {
        if(item.isDisliked){
            let alert = UIAlertController(title: "提示", message: "您已表示疑惑过，是否取消表示疑惑？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                self.manager.dislikeItem(item: item, isToCancel: true)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
                
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            self.manager.dislikeItem(item: item, isToCancel: false)
        }
    }
    
    func moreButtonTappedBroadcast(item: BroadcastItem) {
        let pushTappedSheet = UIAlertController.init(title: "更多", message: nil, preferredStyle: .actionSheet)
        self.present(pushTappedSheet, animated: true, completion: nil)
        pushTappedSheet.addAction(.init(title: "举报该条广播", style: .default, handler:{(action: UIAlertAction) in
            self.manager.reportItem(item: item)
        } ))
        pushTappedSheet.addAction(.init(title: "删除该条广播", style: .default, handler:{(action: UIAlertAction) in
            self.manager.deleteItem(item: item)
        } ))
        
        pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
    }
    
    
}


//MARK:- broadcast manager delegate
extension MyBroadcastViewController{
    func deleteItemSuccess(item: BroadcastItem) {
        self.showTempAlert(info: "删除成功")
        tableView.reloadData()
        tableView.setNeedsDisplay()
    }
    
    func deleteItemFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "删除失败，出bug了")
    }
}

//MARK:- square comment view controller delegate
extension MyBroadcastViewController{
    func popDeletedCircleItem(item: CircleItem) {
        print("you cant pop here    ")
    }
    
    func popDeletedBroadcastItem(item: BroadcastItem) {
        manager.deleteItem(item: item)
    }
}
