//
//  EditProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    
    let smallPadding:CGFloat = 5
    let padding:CGFloat = 10
    
    var profileModel:ProfileModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "更改资料"
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    

    
    //MARK:- tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "更改个人资料"
        case 1:
            cell.textLabel?.text = "更改头像与背景"
        case 2:
            cell.textLabel?.text = "更改照片墙"
        default:
            break
        }
        
        
        let footer = UIView(frame: CGRect(x: padding, y: cell.frame.maxY - 1, width: UIDevice.SCREEN_WIDTH - 2*padding, height: 1))
        footer.backgroundColor = .darkGray
        cell.addSubview(footer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let editTextProfileVC = EditTextProfileViewController()
            editTextProfileVC.profileModel = profileModel
           self.navigationController?.pushViewController(editTextProfileVC, animated: true)
        case 1:
            let editABVC = EditAvatarAndBackgroundViewController()
            self.navigationController?.pushViewController(editABVC, animated: true)
        case 2:
            let editWallVC = EditWallViewController()
            editWallVC.profileModel = profileModel
            self.navigationController?.pushViewController(editWallVC, animated: true)
//                _ = self.presentHGImagePicker(maxSelected: 3, completeHandler: { (assets) in
//                print("共选择了\(assets.count)张图片，分别如下：")
//                for asset in assets {
//                    print(asset)
//                }
//            })
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
}
