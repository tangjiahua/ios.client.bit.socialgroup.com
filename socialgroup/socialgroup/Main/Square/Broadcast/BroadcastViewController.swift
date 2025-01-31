//
//  BroadcastViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/21.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol BroadcastViewControllerDelegate:NSObjectProtocol {
    func hideTitleScrollView()
    func showTitleScrollView()
}

class BroadcastViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, BroadcastManagerDelegate, BroadcastTableViewCellDelegate,SquareCommentViewControllerDelegate,  UINavigationControllerDelegate{
    
    
    
    
    
    
    
    
    
    
    
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
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT - UIDevice.NAVIGATION_BAR_HEIGHT - UIDevice.STATUS_BAR_HEIGHT - UIDevice.HEIGHT_OF_ADDITIONAL_FOOTER), style: .plain)
        tableView.contentInset = .init(top: TitleHeight, left: 0, bottom: UIDevice.TAB_BAR_HEIGHT, right: 0)
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
            manager.fetchNewBroadcastItems()
        }else{
            self.showTempAlert(info: "无法连接网络")
        }
        
        
        
    }
    
    
    
    
    // MARK:- Refresher
    @objc func refreshBroadcast(){
        manager.fetchNewBroadcastItems()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if(self.refresher.isRefreshing){
                self.refresher.endRefreshing()
                self.showTempAlert(info: "刷新失败")
            }
        }
    }
    

}

extension BroadcastViewController{
    
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
    
    
    
    // MARK:- 选中进入评论区
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showCommentVC(item: manager.broadcastItems[indexPath.row])
        
        
    }
    
    private func showCommentVC(item: BroadcastItem){
        let commentVC = SquareCommentViewController()
        commentVC.broadcastItem = item
        commentVC.square_item_type = "broadcast"
        commentVC.square_item_id = String(item.broadcast_id)
        commentVC.delegate = self
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y <= -TitleHeight){
            self.delegate?.showTitleScrollView()
            return
        }else{
            self.delegate?.hideTitleScrollView()
        }
        
//        if (self.lastContentOffset < scrollView.contentOffset.y || (self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y > -TitleHeight)) {
//            // 向上滚动
//            self.delegate?.hideTitleScrollView()
//        }
        
        
        self.lastContentOffset = scrollView.contentOffset.y;
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
//        self.delegate?.showTitleScrollView()
        return true
    }
    
    
    // 滑到底部的时候加载更多的旧item
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == manager.broadcastItems.count - 1){
            manager.fetchOldBroadcastItems()
        }
    }
    
    
    // MARK:- BroadcastManager Delegate
    func BroadcastFetchSuccess(result: String, info: String) {
        tableView.refreshControl?.endRefreshing()
        manager.checkItems()
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
        self.showTempAlert(info: "举报信息已经上传服务器，为您屏蔽了该用户")
        manager.checkItems()
        tableView.reloadData()
    }
    
    func reportItemFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "举报信息未上传服务器，但为您屏蔽了该内容")
        manager.checkItems()
        tableView.reloadData()
    }
    
    func managerDeleteItemSuccess(item: BroadcastItem) {
        manager.removeItem(item: item)
        tableView.reloadData()
        self.showTempAlert(info: "管理员删除成功")
    }
    
    func managerDeleteItemFail(result: String, info: String) {
        self.showTempAlert(info: "管理员删除失败：" + info)
    }
    
    
    
    
    // MARK:- Broadcast Cell delegate
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
            
            
            var inputText:UITextField = UITextField()
            let msgAlert = UIAlertController(title: "举报", message: "描述您的举报理由，能够帮助我们快速排查违规行为", preferredStyle: .alert)
            let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
                // 确定举报
                let content = inputText.text ?? ""
                self.manager.reportItem(item: item, content: content)
                
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                print("cancel")
            }
            msgAlert.addAction(ok)
            msgAlert.addAction(cancel)
            msgAlert.addTextField { (textField) in
                inputText = textField
                inputText.placeholder = "输入理由"
            }
            self.present(msgAlert, animated: true, completion: nil)
            
            
        } ))
        
        if(UserDefaultsManager.getRole() == "1"){
            //管理员可以删除
            pushTappedSheet.addAction(.init(title: "管理员-删除该条广播", style: .default, handler:{(action: UIAlertAction) in
                
                
                var inputText:UITextField = UITextField()
                let msgAlert = UIAlertController(title: "删除", message: "描述您的删除理由，能够帮助我们快速排查违规行为", preferredStyle: .alert)
                let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
                    // 确定举报
                    let content = inputText.text ?? ""
                    self.manager.managerDeleteItem(item: item, content: content)
                    
                    
                }
                let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                    print("cancel")
                }
                msgAlert.addAction(ok)
                msgAlert.addAction(cancel)
                msgAlert.addTextField { (textField) in
                    inputText = textField
                    inputText.placeholder = "输入理由"
                }
                self.present(msgAlert, animated: true, completion: nil)
                
                
            } ))
        }
        
        
        
        pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
    }
    
    func collectionSpaceTapped(item: BroadcastItem) {
        showCommentVC(item: item)
    }
    
    
}

// MARK:- BroadcastManager deleaget
extension BroadcastViewController{
    func deleteItemSuccess(item: BroadcastItem) {
        print("you cant delete here")
    }
    
    func deleteItemFail(result: String, info: String) {
        print("you cant delete here")
    }
}


extension BroadcastViewController{
    
    func popDeletedCircleItem(item: CircleItem) {
        print("cannot delete here")
    }
    
    func popDeletedBroadcastItem(item: BroadcastItem) {
        print("cannot delete here")
    }
    
    func popReportedItemSuccess() {
        self.showTempAlert(info: "举报成功，我们将尽快处理")
        manager.checkItems()
        tableView.reloadData()
    }
    
    func popReportedItemFail() {
        self.showTempAlert(info: "举报没有上传到服务器，但我们为您屏蔽了该内容")
        manager.checkItems()
        tableView.reloadData()
    }
    
    func popManagerDeleteItemSuccess(item: BroadcastItem) {
        self.showTempAlert(info: "管理员删除成功")
        manager.removeItem(item: item)
        tableView.reloadData()
    }
    
    func popManagerDeleteItemSuccess(item: CircleItem) {
        print("useless")
    }
    
}
