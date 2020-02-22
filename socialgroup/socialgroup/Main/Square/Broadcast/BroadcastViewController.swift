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
    
    var delegate:BroadcastViewControllerDelegate?
    
    
    let titleScrollHeight:CGFloat = 40.0
    
    var lastContentOffset:CGFloat = .zero
    
    
    // tableView height calculator
    let padding:CGFloat = 10
    let titleLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    var collectionViewItemHeight:CGFloat{
        return (BroadcastTableViewCell().bounds.width - padding*2) / 3 - 3
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = BroadcastManager()
        manager.delegate = self
        
        
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
        
        
        if(NetworkManager.isNetworking()){
            manager.fetchNewBroadacstItems()
        }else{
            self.showTempAlert(info: "无法连接网络")
        }
        
    }
    

}

extension BroadcastViewController{
    
    // MARK:- Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.broadcastItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier" + String(indexPath.row)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? BroadcastTableViewCell
        
        if(cell == nil){
            cell = BroadcastTableViewCell(style: .default, reuseIdentifier: "identifier")
            cell?.delegate = self
            cell?.initUI(item: manager.broadcastItems[indexPath.row])
            
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
            height += (padding + cellWidth - padding*2)
        }else if(pic_count <= 3){
            height += (padding + collectionViewItemHeight + padding * 2)
        }else if(pic_count <= 6){
            height += (padding + collectionViewItemHeight*2 + padding * 2)
        }else{
            height += (padding + collectionViewItemHeight*3 + padding * 2)
        }
        
        height += padding
        
        return height
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y <= -TitleHeight){
            self.delegate?.showTitleScrollView()
            return
        }
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // 向下滚动
            self.delegate?.showTitleScrollView()
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // 向上滚动
            self.delegate?.hideTitleScrollView()
        }
        self.lastContentOffset = scrollView.contentOffset.y;
        
        
        
//        if(scrollView.contentOffset.y <= 0 ){
//            self.delegate?.showTitleScrollView()
//        }else if(scrollView.contentOffset.y > -40){
//            self.delegate?.hideTitleScrollView()
//
//            if(scrollView.contentOffset.y >= 40){
//            }else if(scrollView.contentOffset.y < 40){
//                self.delegate?.showTitleScrollView()
//            }
            
//    }??       }
    }
    
    // MARK:- BroadcastManager Delegate
    func BroadcastFetchSuccess(result: String, info: String) {
        tableView.reloadData()
    }
    
    func BroadcastFetchFail(result: String, info: String) {
        self.showTempAlert(info: "拉取失败")
    }
    
    
}
