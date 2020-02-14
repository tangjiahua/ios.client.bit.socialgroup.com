//
//  SocialGroupTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/13.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SDWebImage

class SocialGroupTableViewCell: UITableViewCell {
    
    //api
    let api = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_system/avatar/"
    
    //data
    var id:String?
    var name:String?
    var avatar:String?
    
    //ui
    static let cellHeight:CGFloat = 60
    let cellPrivateHeight:CGFloat = 60
    let padding:CGFloat = 10
    let avatarViewHeight:CGFloat = 40
    let avatarViewWidth:CGFloat = 40
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    public func setUpUI(_ item: SocialGroupItem){
        id = item.socialgroupId
        name = item.name
        avatar = item.avatar
        
        self.backgroundColor = .secondarySystemBackground
        
        //avatar
        let avatarView = UIImageView(frame: CGRect(x: padding, y: padding, width: avatarViewWidth, height: avatarViewHeight))
        let url = URL(string: api + id! + "@" + avatar! + ".jpg")
        avatarView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached], progress: nil, completed: nil)
        avatarView.layer.cornerRadius = avatarViewHeight / 2
        avatarView.layer.masksToBounds = true
        
        //name
        let nameLabel = UILabel(frame: CGRect(x: avatarView.frame.maxX + padding, y: padding, width: UIDevice.SCREEN_WIDTH - avatarViewHeight - padding*2, height: avatarViewHeight))
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: avatarViewHeight - 10)
        nameLabel.textAlignment = .natural
        nameLabel.textColor = .label
        
        
        self.addSubview(nameLabel)
        self.addSubview(avatarView)
        //name
        
    }
    
    
    
}
