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

class CircleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CircleManagerDelegate, CircleTableViewCellDelegate{
    
    
    
    
    
    var tableView:UITableView!
    
    var manager:CircleManager!
    var heightForRows:[CGFloat] = []
    var refresher:UIRefreshControl!
    var delegate:CircleViewControllerDelegate?
    let titleScrollHeight:CGFloat = 40.0
    let singleImageViewHeight:CGFloat = UIDevice.SCREEN_WIDTH*2/3
    var lastContentOffset:CGFloat = .zero
    
    // tableView height calculator
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
        // Do any additional setup after loading the view.
        
        
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
            cell?.delegate = self
            cell?.initUI(item: manager.circleItems[indexPath.row])
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
        let cellWidth = CircleTableViewCell().bounds.width
        var height = padding + avatarImageViewHeight + padding + UIDevice.getLabHeigh(labelStr: manager.circleItems[row].content, font: .systemFont(ofSize: contentLabelFontSize), width: cellWidth - padding*2) + padding
        
        let pic_count = manager.circleItems[row].picture_count!

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
        if(indexPath.row == manager.circleItems.count - 1){
            manager.fetchOldCircleItems()
        }
    }
    
    // MARK:- circle Manager delegate
    func CircleFetchSuccess(result: String, info: String) {
        tableView.refreshControl?.endRefreshing()
        
        tableView.reloadData()
    }
    
    func CircleFetchFail(result: String, info: String) {
        print("no more")
    }
}


extension CircleViewController{
    // MARK:- circle tableviewCell delegate
    func avatarTapped(item: CircleItem) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.profileModel = ProfileModel()
        otherProfileVC.profileModel.otherProfileModelDelegate = otherProfileVC
        otherProfileVC.profileModel.setBasicModel()
        otherProfileVC.getProfile(user_id: item.user_id)
        otherProfileVC.modalPresentationStyle = .fullScreen
        self.present(otherProfileVC, animated: true, completion: nil)
    }
}
