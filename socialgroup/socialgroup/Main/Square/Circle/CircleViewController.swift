//
//  CircleViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/21.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol CircleViewControllerDelegate:NSObjectProtocol {
    func hideTitleScrollView()
    func showTitleScrollView()
}

class CircleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CircleManagerDelegate, CircleTableViewCellDelegate, SquareCommentViewControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate{
    
    
    
    
    
    
    
    // manager
    var manager:CircleManager!

    // view
    var tableView:UITableView!
    var refresher:UIRefreshControl!
    
    //delegate
    var delegate:CircleViewControllerDelegate?
    
    //ui
    let titleScrollHeight:CGFloat = 40.0
    let singleImageViewHeight:CGFloat = UIDevice.SCREEN_WIDTH*2/3
    var lastContentOffset:CGFloat = .zero
    let padding:CGFloat = 10
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    var collectionViewItemHeight:CGFloat{
        return (UIDevice.SCREEN_WIDTH - padding*2) / 3 - 3
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // model
        manager = CircleManager()
        manager.delegate = self
        
        //view
        view.backgroundColor = .secondarySystemBackground

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT - UIDevice.NAVIGATION_BAR_HEIGHT - UIDevice.STATUS_BAR_HEIGHT - UIDevice.HEIGHT_OF_ADDITIONAL_FOOTER), style: .plain)
        tableView.contentInset = .init(top: TitleHeight, left: 0, bottom: UIDevice.TAB_BAR_HEIGHT, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(CircleTableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        
        // refresher
        refresher = UIRefreshControl.init()
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshCircle), for: .valueChanged)
        tableView.addSubview(refresher)
        
        
        if(NetworkManager.isNetworking()){
            manager.fetchNewCircleItems()
        }else{
            self.showTempAlert(info: "无法连接网络")
        }
        
    }
    
    
    // MARK:- Refresher
    @objc func refreshCircle(){
        manager.fetchNewCircleItems()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if(self.refresher.isRefreshing){
                self.refresher.endRefreshing()
                self.showTempAlert(info: "刷新失败")
            }
        }
    }

}

extension CircleViewController{
    
    // MARK:- tableView datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.circleItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "identifier" + String(manager.circleItems[indexPath.row].circle_id)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CircleTableViewCell
        
        if(cell == nil){
            cell = CircleTableViewCell(style: .default, reuseIdentifier: "identifier" + String(manager.circleItems[indexPath.row].circle_id))
            cell?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200)
            cell?.delegate = self
            cell?.initUI(item: manager.circleItems[indexPath.row])
            cell?.selectionStyle = .none
            // calculate height for row
        }else{
            for view in cell!.subviews{
                view.removeFromSuperview()
            }
            cell?.initUI(item: manager.circleItems[indexPath.row])
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeightForRow(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentVC = SquareCommentViewController()
        commentVC.circleItem = manager.circleItems[indexPath.row]
        commentVC.square_item_type = "circle"
        commentVC.square_item_id = String(manager.circleItems[indexPath.row].circle_id)
        commentVC.delegate = self
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func calculateHeightForRow(row: Int) -> CGFloat{
        let cellWidth = ScreenWidth - 10
        var height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: manager.circleItems[row].content, font: .systemFont(ofSize: contentLabelFontSize), width: cellWidth - padding*2) + padding
        
        let pic_count = manager.circleItems[row].picture_count!

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y <= -TitleHeight){
            self.delegate?.showTitleScrollView()
            return
        }else{
            self.delegate?.hideTitleScrollView()
        }
        
//        if (self.lastContentOffset < scrollView.contentOffset.y) {
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
        if(indexPath.row == manager.circleItems.count - 1){
            manager.fetchOldCircleItems()
        }
    }
    
    // MARK:- circle Manager delegate
    func CircleFetchSuccess(result: String, info: String) {
        tableView.refreshControl?.endRefreshing()
        manager.checkItems()
        tableView.reloadData()
    }
    
    func CircleFetchFail(result: String, info: String) {
        print("no more")
    }
    
    // delegate
    
    func likeItemSuccess(item: CircleItem, isToCancel: Bool) {
        print("likeItem succuess")
        if(isToCancel){
            item.isLiked = false
            item.like_count -= 1
        }else{
            item.isLiked = true
            item.like_count += 1
        }
        manager.checkItems()
        tableView.reloadData()
    }
    
    func reportItemSuccess(item: CircleItem) {
        self.showTempAlert(info: "举报信息已经上传服务器")
        manager.checkItems()
        tableView.reloadData()
    }
    
    
    
    func likeItemFail(result: String, info: String, isToCancel: Bool) {
        print("likeItem FAil maybe istocancel??")
    }
    
    
    func reportItemFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "举报信息未上传服务器，但为您屏蔽了该内容")
        manager.checkItems()
        tableView.reloadData()
    }
    
    // delete delegate
    func deleteItemSuccess(item: CircleItem) {
        self.showTempAlert(info: "删除成功")
        self.refreshCircle()
    }
    
    func deleteItemFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "删除失败，出bug了")
    }
    
    func managerDeleteItemSuccess(item: CircleItem) {
       manager.removeItem(item: item)
        tableView.reloadData()
        self.showTempAlert(info: "管理员删除成功")
    }
    
    func managerDeleteItemFail(result: String, info: String) {
        self.showTempAlert(info: "管理员删除失败：" + info)
    }
    
    
}


extension CircleViewController{
    // MARK:- circle tableview Cell delegate
    func avatarTappedCircle(item: CircleItem) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: item.user_id)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
    }
    
    func likeButtonTappedCircle(item: CircleItem) {
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
    
    func commentButtonTappedCircle(item: CircleItem) {
        print("commentr")
        let commentVC = SquareCommentViewController()
        commentVC.circleItem = item
        commentVC.square_item_type = "circle"
        commentVC.square_item_id = String(item.circle_id)
        commentVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(commentVC, animated: true)
        
        if(item.comment_count == 0){
            commentVC.writeComment()
        }
    }
    
    
    
    func moreButtonTappedCircle(item: CircleItem) {
        let pushTappedSheet = UIAlertController.init(title: "更多", message: nil, preferredStyle: .actionSheet)
        self.present(pushTappedSheet, animated: true, completion: nil)
            pushTappedSheet.addAction(.init(title: "举报该条广播", style: .default, handler:{(action: UIAlertAction) in
            
                
                
                
                if(item.user_id == Int(UserDefaultsManager.getUserId())){
                    self.showTempAlert(info: "别举报了，自觉删除吧！")
                }else{
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
                }
                
                
                
                
        } ))
        
        
        if(UserDefaultsManager.getRole() == "1"){
            //管理员可以删除
            pushTappedSheet.addAction(.init(title: "管理员-删除该条动态", style: .default, handler:{(action: UIAlertAction) in
                
                
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
        if(item.user_id == Int(UserDefaultsManager.getUserId())){
            // 说明是我自己发的内容
            pushTappedSheet.addAction(.init(title: "删除我的动态", style: .default, handler:{(action: UIAlertAction) in
                self.manager.deleteItem(item: item)
            } ))
        }
    }
    
    
    
}

// MARK:- SquareCommentViewController Delegate
extension CircleViewController{
    func popDeletedCircleItem(item: CircleItem) {
        manager.deleteItem(item: item)
    }
    
    func popDeletedBroadcastItem(item: BroadcastItem) {
        print("you cant pop here")
    }
    
    func popReportedItemSuccess(){
        self.showTempAlert(info: "举报成功，我们将尽快处理")
        manager.checkItems()
        tableView.reloadData()
    }
    func popReportedItemFail(){
        self.showTempAlert(info: "举报没有上传到服务器，但我们为您屏蔽了该内容")
        manager.checkItems()
        tableView.reloadData()
    }
    func popManagerDeleteItemSuccess(item: CircleItem) {
        self.showTempAlert(info: "管理员删除成功")
        manager.removeItem(item: item)
        tableView.reloadData()
    }
    
    func popManagerDeleteItemSuccess(item: BroadcastItem) {
        print("useless")
    }
}
