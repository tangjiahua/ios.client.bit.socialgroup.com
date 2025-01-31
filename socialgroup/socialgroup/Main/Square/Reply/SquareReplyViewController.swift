//
//  SquareReplyViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SquareReplyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SquareReplyManagerDelegate, SquareReplyTableViewCellDelegate, WriteViewControllerDelegate {
    
    
    
    
    
    
    var commentItem:SquareCommentItem!
    var manager:SquareReplyManager!
    var refresher:UIRefreshControl!
    
    var tableView:UITableView!
    
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    let ScreenHeight = UIDevice.SCREEN_HEIGHT
    
    
    // tableView height calculator
    let cellInitPadding:CGFloat = 10
    let padding:CGFloat = 10
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16

    // tableView height calculator
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20

    let toolBarHeight:CGFloat = 50
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //view
        view.backgroundColor = .secondarySystemBackground
        
        self.title = "回复"
        // Do any additional setup after loading the view.
        
        initUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let vc = self.navigationController!.viewControllers.first! as! BaseNavigationViewController
        vc.viewIsInTransition = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let vc = self.navigationController!.viewControllers.first! as! BaseNavigationViewController
        vc.viewIsInTransition = false
    }
    
    
    
    func initData(commentItem:SquareCommentItem){
        self.commentItem = commentItem
    }
    

    
    private func initUI(){
        
        //model
        manager = SquareReplyManager()
        manager.delegate = self
        manager.initSquareReplyManger(squareCommentItem: commentItem)
        
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        
        // refresher
        refresher = UIRefreshControl.init()
        tableView.refreshControl = refresher
        refresher.addTarget(self, action: #selector(refreshReplyVC), for: .valueChanged)
        tableView.addSubview(refresher)


        if(NetworkManager.isNetworking()){
            manager.fetchSquareReplyItems()
        }else{
            self.showTempAlert(info: "无法连接网络")
        }
        
    }
    
    @objc func refreshReplyVC(){
        manager.fetchSquareReplyItems()
    }
    
    private func calculateReplyCellHeight(itemIndex: Int) -> CGFloat{
        let height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: "回复 " + manager.squareReplyItems[itemIndex].reply_to_user_nickname + " :  ", font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2 - 10) + padding + UIDevice.getLabHeigh(labelStr:  manager.squareReplyItems[itemIndex].content, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2 - 10) + padding*2
        
        return height
    }
}


extension SquareReplyViewController{
    // MARK:- tableview datasourece
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.squareReplyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = commentItem.square_item_type + commentItem.square_item_id + manager.squareReplyItems[indexPath.row].comment_id + manager.squareReplyItems[indexPath.row].reply_id
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareReplyTableViewCell
        if(cell == nil){
            cell = SquareReplyTableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.delegate = self
            cell?.initUI(item: manager.squareReplyItems[indexPath.row])
            cell?.selectionStyle = .none
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        calculateReplyCellHeight(itemIndex:indexPath.row)
    }
    
    
    
    // MARK:- square reply manager delegate
    
    func fetchSquareReplySuccess() {
        tableView.reloadData()
        refresher.endRefreshing()
        print("fetch reply success")
    }
    
    func fetchSquareReplyFail() {
        print("fetch reply fail")
    }
    
    func pushReplySuccess() {
        manager.fetchSquareReplyItems()
        print("push success")
        self.showTempAlert(info: "回复成功")
    }
    
    func pushReplyFail() {
        self.showTempAlert(info: "回复失败")
    }
    
    func reportReplySuccess(item: SquareReplyItem) {
        self.showTempAlert(info: "举报信息已经上传服务器，为您屏蔽了该用户")
        manager.checkItems()
        tableView.reloadData()
    }
    
    func reportReplyFail(result: String, info: String) {
        self.showTempAlertWithOneSecond(info: "举报信息未上传服务器，但为您屏蔽了该用户")
        manager.checkItems()
        tableView.reloadData()
    }
    
    
    
    
    
    // MARK:- square reply cell delegate
    func avatarTappedReply(item: SquareReplyItem) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: Int(item.reply_from_user_id)!)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
    }
    
    func cellTappedReply(item: SquareReplyItem) {
        
        
        let writeReplyVC = WriteViewController()
        writeReplyVC.initReplyToReplyTextView(limit: 200, squareReplyItem: item)
        writeReplyVC.delegate = self
        let nc = UINavigationController(rootViewController: writeReplyVC)
        self.present(nc, animated: true, completion: nil)
    }
    
    
    func cellReplyLongPressed(item: SquareReplyItem) {
        if(item.reply_from_user_id.equals(str: UserDefaultsManager.getUserId())){
            // 说明点击的是自己的回复
            let pushTappedSheet = UIAlertController.init(title: "选项", message: nil, preferredStyle: .actionSheet)
            self.present(pushTappedSheet, animated: true, completion: nil)
            pushTappedSheet.addAction(.init(title: "删除我的回复", style: .default, handler:{(action: UIAlertAction) in
                self.manager.deleteMyReply(item: item)
                    
                }))
            pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            
        }else{
            // 说明是别人的回复
            let pushTappedSheet = UIAlertController.init(title: "选项", message: nil, preferredStyle: .actionSheet)
            self.present(pushTappedSheet, animated: true, completion: nil)
            pushTappedSheet.addAction(.init(title: "举报该回复", style: .default, handler:{(action: UIAlertAction) in
                
                var inputText:UITextField = UITextField()
                let msgAlert = UIAlertController(title: "举报", message: "描述您的举报理由，能够帮助我们快速排查违规行为", preferredStyle: .alert)
                let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
                    // 确定举报
                    let content = inputText.text ?? ""
                    self.manager.reportReply(item: item, content: content)
                    
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
                
                
                    
                }))
            pushTappedSheet.addAction(.init(title: "取消", style: .cancel, handler: { (action) in
                
            }))
        }
        
        
        
    }
    
    
    func replyToUserTappedReply(item: SquareReplyItem) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: Int(item.reply_to_user_id)!)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    // MARK: - write view controller delegate
    func pushComment(content: String) {
        print("push comment in squareREplyVC")
        // no need
    }
    
    func pushReplyToComment(content: String, item: SquareCommentItem) {
        print("push reply to comment in squareReplyVC")
        // no need
    }
    
    func pushReplyToReply(content: String, item: SquareReplyItem) {
        manager.pushReplyToReply(content: content, replyItem: item)
    }
    
    func deleteMyReplySuccess(item: SquareReplyItem) {
        self.showTempAlert(info: "删除成功")
        tableView.reloadData()
    }
    
    func deleteMyReplyFail(result: String, info: String) {
        self.showTempAlert(info: info)
    }
    
}
