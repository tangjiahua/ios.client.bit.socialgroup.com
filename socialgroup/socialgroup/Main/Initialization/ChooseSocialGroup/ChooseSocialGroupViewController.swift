//
//  ChooseSocialgroupViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/13.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class ChooseSocialGroupViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, ChooseSocialGroupModelDelegate {
    
    
    
    //model
    var chooseSocialGroupModel:ChooseSocialGroupModel?
    
    //UI
    var ScreenWidth = UIDevice.SCREEN_WIDTH
    var ScreenHeight = UIDevice.SCREEN_HEIGHT
    let padding:CGFloat = 15
    let hintLabelHeight:CGFloat = 70
    let hintLabelWidth:CGFloat = UIDevice.SCREEN_WIDTH
    let hintLabelFontSize:CGFloat = 70
    
    //socialgroup table view
    var socialGroupTableView:UITableView?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground

        // Do any additional setup after loading the view.
        
        // 选择社群label
        let hintString = "选择加入社群"
        let hintLabel = UILabel(frame: CGRect(x: padding, y: UIDevice.STATUS_BAR_HEIGHT, width: (hintLabelWidth - padding*2)*2/3, height: hintLabelHeight))
        hintLabel.text = hintString
        hintLabel.font = .boldSystemFont(ofSize: hintLabelFontSize)
        hintLabel.adjustsFontSizeToFitWidth = true
        hintLabel.textColor = .label
        view.addSubview(hintLabel)
        
        
        
        socialGroupTableView = UITableView(frame: CGRect(x: 0, y: hintLabel.frame.maxY + padding, width: ScreenWidth, height: ScreenHeight - UIDevice.STATUS_BAR_HEIGHT - hintLabelHeight - padding * 2), style: .plain)
        socialGroupTableView?.backgroundColor = .secondarySystemBackground
        socialGroupTableView?.delegate = self
        socialGroupTableView?.dataSource = self
        view.addSubview(socialGroupTableView!)
        
        //delegate
        chooseSocialGroupModel?.delegate = self
        chooseSocialGroupModel?.sendFetchSocialGroupListRequest()
        
    }
    
    // MARK:- tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseSocialGroupModel?.socialGroupList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SocialGroupTableViewCell()
        cell.setUpUI(chooseSocialGroupModel!.socialGroupList[indexPath.row])
            
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SocialGroupTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "提示", message: "您是否确认加入" + chooseSocialGroupModel!.socialGroupList[indexPath.row].name, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
            //确定加入
            self.show(text: "正在加入")
            self.chooseSocialGroupModel!.sendJoinSocialGroupRequest(self.chooseSocialGroupModel!.socialGroupList[indexPath.row].socialgroupId)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK:- chooseSocialGroupDelegate
    func receiveFetchSocialGroupListSuccessResponse() {
        socialGroupTableView?.reloadData()
        socialGroupTableView?.setNeedsDisplay()
    }
    
    func receiveFetchSocialGroupListFailResponse(result: String, info: String) {
        let alert = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func receiveJoinSocialGroupSuccessResponse(result: String, info: String) {
        self.hideHUD()
        let alert = UIAlertController(title: "提示", message: "成功加入该社群！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            // 成功加入的结果
            UserDefaultsManager.setBasicUserInfo(self.chooseSocialGroupModel!.account!, self.chooseSocialGroupModel!.userId!, self.chooseSocialGroupModel!.password!, self.chooseSocialGroupModel!.socialGroupId!)
            UserDefaultsManager.setLoginInfo()
            UIApplication.shared.windows.first?.rootViewController = MainController()
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func receiveJoinSocialGroupFailResponse(result: String, info: String) {
        self.hideHUD()
        let alert = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
