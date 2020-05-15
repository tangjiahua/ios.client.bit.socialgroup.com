//
//  PushMessageViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/15.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

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
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        models = manager.getPushMessageModels()
        manager.fetchFromServer()
//        manager.delegate = self
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier" + String(models[indexPath.row].push_message_id)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if(cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier: "identifier" + String(models[indexPath.row].push_message_id))
            cell?.textLabel?.text = "\(models[indexPath.row].push_message_id), \(models[indexPath.row].type), \(models[indexPath.row].content)"
            print(models[indexPath.row].create_date)
        }else{
            
        }
        
        
        return cell!
        
    }
    
    
}
