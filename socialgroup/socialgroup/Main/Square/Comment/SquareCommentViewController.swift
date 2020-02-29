//
//  SquareCommentViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SquareCommentViewController: BaseViewController, UINavigationControllerDelegate, BroadcastTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource, SquareCommentManagerDelegate, SquareCommentTableViewCellDelegate, SquareJudgeTableViewCellDelegate, WriteViewControllerDelegate {
    
    
    
    
    
    
    
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
        view.backgroundColor = .secondarySystemBackground
        self.title = "详情"
        
        initUI()
    }
    

    func initUI(){
        
        // model
        manager = SquareCommentManager()
        manager.delegate = self
        manager.initSquareCommentManager(square_item_type: square_item_type, square_item_id: square_item_id)

        // view
        view.backgroundColor = .secondarySystemBackground

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT), style: .plain)
        tableView.contentInset = .init(top: 0, left: 0, bottom: toolBarHeight + padding/2, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
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
        let cellWidth = ScreenWidth
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
    
    private func calculateCommentCellHeight(itemIndex: Int) -> CGFloat{
        var height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: manager.squareCommentItems[itemIndex].content, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2) + padding*2
        if(!manager.squareCommentItems[itemIndex].reply_count.equals(str: "0")){
            height = height + moreReplyLabelHeight + padding/2
        }
        
        return height
    }

}


extension SquareCommentViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 原square item高度
        if(indexPath.row == 0){
            if(square_item_type.equals(str: "broadcast")){
                return calculateHeightForOriginalBroadcast()
            }else{
                
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
    
    
    // MARK:- tableview delegate
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
            }
            return cell!
            
            
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
        writeCommentVC.initTextView(limit: 200, writeType: "comment", square_item_type: manager.square_item_type, square_item_id: manager.square_item_id)
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
    func likeButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    func commentButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    func dislikeButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    func moreButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    // MARK:- comment cell delegate
    func avatarTappedComment(item: SquareCommentItem) {
        
    }
    
    func seeMoreReply(item: SquareCommentItem) {
        
    }
    
    // MARK: - judge cell delegate
    func SquareJudgeTableViewCellAvatarTapped(item: SquareJudgeItem) {
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
    }
    
    func fetchSquareLikeItemsSuccess() {
        tableView.reloadData()
        self.refresher.endRefreshing()
        print("fetch success")
    }
    
    func fetchSquareLikeItemsFail() {
        print("fetch fail")
    }
    
    func fetchSquareDislikeItemsSuccess() {
        tableView.reloadData()
        self.refresher.endRefreshing()
        print("fetch success")
    }
    
    func fetchSquareDislikeItemsFail() {
        print("fetch fail")
    }
    
    func pushCommentSuccess() {
//        manager.fetchSquareCommentItems()
        self.showTempAlert(info: "评论成功")
    }
    
    func pushCommentFail() {
        self.showTempAlert(info: "评论失败")
    }
    
    
    //MARK:- WriteViewController Delegate
    func pushComment(content: String) {
        manager.pushComment(content: content)
    }
    
    func pushReply() {
        print("push reply in SquareCommentViewController")
    }
    
}
