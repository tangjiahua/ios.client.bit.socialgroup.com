//
//  PushMessageViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/15.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PushMessageViewController: BaseViewController, UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    //view
    var tableView:UITableView!
    
    //model
    var manager = PushMessageManager.manager
    var models:[PushMessageModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // view
        view.backgroundColor = .secondarySystemBackground
        self.title = "消息"
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(PushMessageTableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        models = manager.getPushMessageModels()
        manager.fetchFromServer()
//        manager.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let padding:CGFloat = 10
        let titleLabelHeight:CGFloat = 20
        let contentLabelFontSize:CGFloat = 16
        let ScreenWidth = UIDevice.SCREEN_WIDTH
        let str = "现在您可以查看对方的私密介绍了，如果您再回戳TA，那么TA也会收到提醒并能够查看您的私密介绍"
        let dateLabelHeight:CGFloat = 10
        
        
        var height:CGFloat = 0
        height = height + padding + dateLabelHeight + padding + titleLabelHeight + padding + titleLabelHeight
        if(models[indexPath.row].type == 3){
            height = height + UIDevice.getLabHeigh(labelStr: str, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2 - 10) + padding
            
        }
        height = height + padding*2
        
        return height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier" + String(models[indexPath.row].push_message_id)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PushMessageTableViewCell
//        cell?.selectionStyle = .none
        if(cell == nil){
            
            cell = PushMessageTableViewCell(style: .default, reuseIdentifier: "identifier" + String(models[indexPath.row].push_message_id))
            cell!.initUI(model: models[indexPath.row])
            
        }else{
            if(models[indexPath.row].is_checked == true){
                for i in cell!.subviews{
                    i.removeFromSuperview()
                }
                cell?.initUI(model: models[indexPath.row])
            }
        }
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(models[indexPath.row].type == 3){
            // 戳一戳
            let parameters = getDictionaryFromJSONString(jsonString: models[indexPath.row].content)
            let json = JSON(parameters)
            let user_id = json["user_id"].int!
            self.showOtherProfile(userId: user_id)
        }else if(models[indexPath.row].type == 1 || models[indexPath.row].type == 2){
            // 评论或者回复
            let parameters = getDictionaryFromJSONString(jsonString: models[indexPath.row].content)
            print(models[indexPath.row].content)
            let json = JSON(parameters)
            let square_item_type = json["square_item_type"].string!
            let square_item_id = json["square_item_id"].int!
            
            
            
            fetchParticularSquareItem(type: square_item_type, id: square_item_id)
            
        }
        
        
        // 点击查看按钮变成灰色
        manager.checkedPushMessage(id: models[indexPath.row].push_message_id)
        models[indexPath.row].is_checked = true
        tableView.reloadData()
        
    }
    
    // 网络请求 获取特定的广播Item
    private func fetchParticularSquareItem(type:String, id:Int){
        
        let parameters:Parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":type, "square_item_id":String(id), "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        
        Alamofire.request(NetworkManager.SQUARE_FETCH_PARTICULAR_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.result{
                case .success:
                    if let data = response.result.value{
                        let json = JSON(data)
                        let result = json["result"].string!
                        if(result.equals(str: "1")){
                            
                            let info = json["info"]
                            let items = info["item"].array!
                            if(items.count == 0){
                                // 该item应该已经被删除了
                                self.showMessage(info: "抱歉，该条内容已被删除")
                                
                            }else{
                                
                                // 如果是broadcast
                                if(type.equals(str: "broadcast")){
                                    let item = items[0]
                                    
                                    // 获取item信息
                                    let broadcast_id = Int(item["broadcast_id"].string!)!
                                    let type = Int(item["type"].string!)!
                                    let title = item["title"].string!
                                    let content = item["content"].string!
                                    let create_date = item["create_date"].string!
                                    let comment_count = Int(item["comment_count"].string!)!
                                    let like_count = Int(item["like_count"].string!)!
                                    let dislike_count = Int(item["dislike_count"].string!)!
                                    let picture_count = Int(item["picture_count"].string!)!
                                    
                                    let broadcastItem = BroadcastItem(broadcast_id: broadcast_id, type: type, title: title, content: content, create_date: create_date, comment_count: comment_count, like_count: like_count, dislike_count: dislike_count, picture_count: picture_count)
                                    
                                    //获取是否点赞过
                                    let like_str = info["like"].string!
                                    let liked_id_array:[String] = like_str.components(separatedBy: "@")
                                    for liked_id in liked_id_array{
                                        if(!liked_id.equals(str: "")){
                                            
                                            broadcastItem.isLiked = true
                                            
                                        }
                                    }
                                    
                                    // 获取是否点diss过
                                    let dislike_str = info["dislike"].string!
                                    let disliked_id_array:[String] = dislike_str.components(separatedBy: "@")
                                    for disliked_id in disliked_id_array{
                                        if(!disliked_id.equals(str: "")){
                                            broadcastItem.isDisliked = true
                                        }
                                    }
                                    
                                    // 展示broadcastComment
                                    self.showBroadcastCommentVC(item: broadcastItem)
                                    
                                }else if(type.equals(str: "circle")){
                                    
                                    
                                    let info = json["info"]
                                    let items = info["item"].array!
                                    
                                    let item = items[0]
                                    let circle_id = Int(item["circle_id"].string!)!
                                    let user_id = Int(item["user_id"].string!)!
                                    let user_nickname = item["user_nickname"].string!
                                    let user_avatar = Int(item["user_avatar"].string!)!
                                    let type = Int(item["type"].string!)!
                                    let content = item["content"].string!
                                    let create_date = item["create_date"].string!
                                    let comment_count = Int(item["comment_count"].string!)!
                                    let like_count = Int(item["like_count"].string!)!
                                    let picture_count = Int(item["picture_count"].string!)!
                                    
                                    let circleItem = CircleItem(circle_id: circle_id, user_id:user_id, user_nickname:user_nickname, user_avatar:user_avatar,  type: type, content: content, create_date: create_date, comment_count: comment_count, like_count: like_count, picture_count: picture_count)

                                    
                                    let like_str = info["like"].string!
                                    let liked_id_array:[String] = like_str.components(separatedBy: "@")
                                    for liked_id in liked_id_array{
                                        if(!liked_id.equals(str: "")){
                                            circleItem.isLiked = true
                                            
                                        }
                                    }
                                    
                                    // 展示circleCOmment
                                    self.showCircleCommentVC(item: circleItem)
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }else{
                            
                            self.showTempAlert(info: "拉取失败")
                        }
                        
                    }else{
                        self.showTempAlert(info: "解析失败")
                    }
                case .failure:
                    self.showTempAlert(info: "网络请求失败")
                }
                
                // 请求停止
            }
    }
    
    
    private func showMessage(info:String){
        self.showTempAlert(info: info)
    }
    
    private func showCircleCommentVC(item: CircleItem){
        let commentVC = SquareCommentViewController()
        commentVC.circleItem = item
        commentVC.square_item_type = "circle"
        commentVC.square_item_id = String(item.circle_id)
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    private func showBroadcastCommentVC(item: BroadcastItem){
        let commentVC = SquareCommentViewController()
        commentVC.broadcastItem = item
        commentVC.square_item_type = "broadcast"
        commentVC.square_item_id = String(item.broadcast_id)
        commentVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    // json string 转 字典
    private func getDictionaryFromJSONString(jsonString:String) -> NSDictionary{

        let jsonData:Data = jsonString.data(using: .utf8)!

        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
        

    }
    
    
}
