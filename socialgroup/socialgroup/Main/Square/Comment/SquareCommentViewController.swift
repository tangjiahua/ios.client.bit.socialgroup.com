//
//  SquareCommentViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SquareCommentViewController: BaseViewController, UINavigationControllerDelegate, BroadcastTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource, SquareCommentManagerDelegate, SquareCommentTableViewCellDelegate {
    
    
    
    
    var square_item_id:String!
    var broadcastItem:BroadcastItem!
    var circleItem:CircleItem!
    var square_item_type:String!   //1代表broadcast
    var tableView:UITableView!
    var segment:UISegmentedControl!
    
    // model
    var manager:SquareCommentManager!
    var interactionSegmentIndex:Int!
    
    
    
    
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
    let interactionSegmentHeight:CGFloat = 50
    let interactionSegmentItemWidth:CGFloat = 80
    let commentCellHeight:CGFloat = 200
    // tableView height calculator
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20
    
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

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: UIDevice.SCREEN_HEIGHT - UIDevice.NAVIGATION_BAR_HEIGHT - UIDevice.STATUS_BAR_HEIGHT - UIDevice.HEIGHT_OF_ADDITIONAL_FOOTER), style: .plain)
        tableView.contentInset = .init(top: 0, left: 0, bottom: UIDevice.TAB_BAR_HEIGHT, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        view.addSubview(tableView)
//
//        // refresher
//        refresher = UIRefreshControl.init()
//        tableView.refreshControl = refresher
//        refresher.addTarget(self, action: #selector(refreshBroadcast), for: .valueChanged)
//        tableView.addSubview(refresher)
//
//
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
        var height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: manager.squareCommentItems[itemIndex].content, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2) + padding
        if(!manager.squareCommentItems[itemIndex].reply_count.equals(str: "0")){
            height = height + moreReplyLabelHeight + padding
        }
        
        return height
    }

}


extension SquareCommentViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //segment
        if(indexPath.row == 1){
            return interactionSegmentHeight
        }
        
        
        if(square_item_type.equals(str: "broadcast")){
            if(indexPath.row == 0){
                return calculateHeightForOriginalBroadcast()
            }
            
            return calculateCommentCellHeight(itemIndex: indexPath.row - 2)
        }
        
        
        
        return 0
    }
    
    
    // MARK:- tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + manager.squareCommentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(square_item_type.equals(str: "broadcast")){
            if(indexPath.row == 0){
                // 原item
                return initOriginalBroadcastItem()
                
            }else if(indexPath.row == 1){
                // interaction Segment
                return initInteractionSegment()
                
            }else{
                // 具体评论
                
                let identifier = "broadcastComment" + manager.squareCommentItems[indexPath.row-2].comment_id
                var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SquareCommentTableViewCell
                if(cell == nil){
                    cell = SquareCommentTableViewCell(style: .default, reuseIdentifier: identifier)
                    cell?.delegate = self
                    cell?.initUI(item: manager.squareCommentItems[indexPath.row-2])
                    cell?.selectionStyle = .none
                }
                return cell!
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
                let tags = ["点赞","评论","疑惑"]
                segment = UISegmentedControl(items: tags)
                segment.frame = CGRect(x: padding, y: 0, width: interactionSegmentItemWidth, height: interactionSegmentHeight)
                self.segment?.selectedSegmentIndex = 1
                self.segment?.addTarget(self, action: #selector(segmentDidChange(_:)), for: .valueChanged)
                cell?.addSubview(segment)
            }
            return cell!
            
            
        }
        return cell!
    }
    
    
    @objc func segmentDidChange(_ sender: UISegmentedControl){
        self.interactionSegmentIndex = sender.selectedSegmentIndex
        print(sender.selectedSegmentIndex)
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
    
    // MARK:- SquareCommentManager delegate
    func fetchSquareCommentItemsSuccess() {
        tableView.reloadData()
        print("fetch success")
    }
    
    func fetchSquareCommentItemsFail() {
        print("fetchFail")
    }
}
