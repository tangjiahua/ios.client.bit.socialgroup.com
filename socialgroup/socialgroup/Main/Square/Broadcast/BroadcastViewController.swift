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

class BroadcastViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, BroadcastManagerDelegate, BroadcastTableViewCellDelegate{
    
    
    var manager:BroadcastManager!
    
    var heightForRows:[CGFloat] = []
    
    
    var tableView:UITableView!
    var refresher:UIRefreshControl!
    
    var delegate:BroadcastViewControllerDelegate?
    
    
    let titleScrollHeight:CGFloat = 40.0
    let singleImageViewHeight:CGFloat = UIDevice.SCREEN_WIDTH*2/3
    
    var lastContentOffset:CGFloat = .zero
    
    
    // tableView height calculator
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
            cell?.delegate = self
            cell?.initUI(item: manager.broadcastItems[indexPath.row])
            cell?.selectionStyle = .none
            // calculate height for row
            heightForRows.append(calculateHeightForRow(row: indexPath.row))
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRows[indexPath.row]
    }
    
    func calculateHeightForRow(row: Int) -> CGFloat{
        let cellWidth = BroadcastTableViewCell().bounds.width
        var height = padding + titleLabelHeight + padding + dateLabelHeight + padding + UIDevice.getLabHeigh(labelStr: manager.broadcastItems[row].content, font: .systemFont(ofSize: contentLabelFontSize), width: cellWidth - padding*2) + padding
        
        let pic_count = manager.broadcastItems[row].picture_count!
        
        if(pic_count == 0){
            
        }else if(pic_count == 1){
            height += (padding + singleImageViewHeight)
        }else if(pic_count <= 3){
            height += (padding + collectionViewItemHeight + padding * 2)
        }else if(pic_count <= 6){
            height += (padding + collectionViewItemHeight*2 + padding * 2)
        }else{
            height += (padding + collectionViewItemHeight*3 + padding * 2)
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
        }
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // 向上滚动
            self.delegate?.hideTitleScrollView()
        }
        self.lastContentOffset = scrollView.contentOffset.y;
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.delegate?.showTitleScrollView()
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
        
        tableView.reloadData()
    }
    
    func BroadcastFetchFail(result: String, info: String) {
        print("no more")
    }
    
    
}
