//
//  SquareCommentViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class SquareCommentViewController: BaseViewController, UINavigationControllerDelegate, BroadcastTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource, SquareCommentManagerDelegate {
    
    
    
    var broadcastItem:BroadcastItem!
    var circleItem:CircleItem!
    var square_item_type:Int!   //1代表broadcast
    var tableView:UITableView!
    
    // model
    var manager:SquareCommentManager!
    
    
    
    
    
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
//        if(NetworkManager.isNetworking()){
//            manager.fetchNewBroadcastItems()
//        }else{
//            self.showTempAlert(info: "无法连接网络")
//        }
    }
    
    func calculateHeightForRow() -> CGFloat{
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

}


extension SquareCommentViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(square_item_type == 1 && indexPath.row == 0){
            return calculateHeightForRow()
        }
        
        return 0
    }
    
    // MARK:- tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(square_item_type == 1 && indexPath.row == 0){
            let identifier = "squareComment" + String(broadcastItem.broadcast_id)
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BroadcastTableViewCell
            
            if(cell == nil){
                cell = BroadcastTableViewCell(style: .default, reuseIdentifier: identifier)
                cell?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 200)
                cell?.delegate = self
                cell?.initUI(item: broadcastItem)
                cell?.selectionStyle = .none
                cell?.initUI(item: broadcastItem)
            }
            return cell!
        }
        
        return UITableViewCell()
    }
    
    // MARK:- broadcast cell delegate
    func likeButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    func commentButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    func dislikeButtonTappedBroadcast(item: BroadcastItem) {
        
    }
    
    func moreButtonTappedBroadcast(item: BroadcastItem) {
        
    }
}
