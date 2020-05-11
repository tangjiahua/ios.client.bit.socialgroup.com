//
//  SquareJudgeTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol SquareJudgeTableViewCellDelegate:NSObjectProtocol {
    func SquareJudgeTableViewCellAvatarTapped(item:SquareJudgeItem)
}

class SquareJudgeTableViewCell: UITableViewCell {
    
    var delegate:SquareJudgeTableViewCellDelegate?
    
    //view
    var avatarImageView:UIImageView!
    var nicknameLabel:UILabel!
    
    let padding:CGFloat = 10
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20
    
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    
    var item:SquareJudgeItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI(item:SquareJudgeItem){
        self.item = item
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.layer.masksToBounds = true
        
        // avatar
        avatarImageView = UIImageView(frame: CGRect(x: padding, y: padding, width: avatarImageViewHeight, height: avatarImageViewHeight))
        let avatarUrlStr = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/profile/avatar/thumbnail/" + String(item.user_id) + "@" + String(item.user_avatar) + ".jpg"
        avatarImageView.sd_setImage(with: URL(string: avatarUrlStr), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .allowInvalidSSLCertificates], context: nil, progress: nil, completed: nil)
        avatarImageView.layer.cornerRadius = avatarImageViewHeight/2
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.masksToBounds = true
        self.addSubview(avatarImageView)
        
        let avatarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTapGestureRecognizer)
        
        // nickname
        nicknameLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + padding, y: padding, width: ScreenWidth - padding*2 - avatarImageViewHeight - padding, height: avatarImageViewHeight))
        nicknameLabel.font = .systemFont(ofSize: nicknameLabelHeight)
        nicknameLabel.text = item.user_nickname
        nicknameLabel.textAlignment = .natural
        self.addSubview(nicknameLabel)
    }
    
    @objc func avatarTapped(){
        self.delegate?.SquareJudgeTableViewCellAvatarTapped(item: item)
    }

}
