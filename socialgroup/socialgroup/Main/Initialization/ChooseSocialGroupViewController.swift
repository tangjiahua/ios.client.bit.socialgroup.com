//
//  ChooseSocialgroupViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/13.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class ChooseSocialGroupViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //model
    var chooseSocialGroupModel:ChooseSocialGroupModel?
    
    //UI
    var ScreenWidth = UIDevice.SCREEN_WIDTH
    var ScreenHeight = UIDevice.SCREEN_HEIGHT
    let padding:CGFloat = 15
    let hintLabelHeight:CGFloat = 50
    let hintLabelWidth:CGFloat = UIDevice.SCREEN_WIDTH
    let hintLabelFontSize:CGFloat = 50
    
    //socialgroup table view
    var socialGroupTableView:UITableView?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground

        // Do any additional setup after loading the view.
        
        // 选择社群label
        let hintString = "选择加入社群"
        let hintLabel = UILabel(frame: CGRect(x: padding, y: UIDevice.STATUS_BAR_HEIGHT, width: (hintLabelWidth - padding) / 2, height: hintLabelHeight))
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
        
            
        
    }
    
    // MARK:- tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "hello")
        return cell
    }
    
    
}
