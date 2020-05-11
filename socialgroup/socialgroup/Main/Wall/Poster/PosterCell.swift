//
//  PosterCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/3/1.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SDWebImage

class PosterCell: UITableViewCell  {
    
    let wallAvatarWidth:CGFloat = 40
//    let wallPadding:CGFloat = 20
    let padding:CGFloat = 10
//    let wallPushDateHeight:CGFloat = 12
//    let wallMediumPadding:CGFloat = 10
//    let wallSmallerPadding:CGFloat = 5
    let wallPosterRatio:CGFloat = 1.2
    let publisherHeight:CGFloat = 25
    let briefFontSize:CGFloat = 80
    let briefLabelHeight:CGFloat = 35
    let briefLabelWidth:CGFloat = 300
    
    var bgImageView:UIImageView!//poster
    var bgView:UIView!//poster
    var titleLabel:UILabel!//brief
//    var contentLabel:UILabel//no use
    var avatarView:UIImageView!//avatar
    var publisher:UILabel!//publisjher
    var pushdate:UILabel!//pushdate
    
    var model:PosterModel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        bgView.frame = CGRect(x: padding, y: avatarView!.frame.maxY + padding, width: ScreenWidth-padding*2, height: (ScreenWidth-padding*2)*wallPosterRatio)
//
//        bgView.layoutIfNeeded()
////        bgView.laye
//
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSubViews(){
        
        self.backgroundColor = UIColor.secondarySystemBackground
        //avatar
        avatarView = UIImageView(frame: CGRect(x: padding, y: padding, width: wallAvatarWidth, height: wallAvatarWidth))
        avatarView.contentMode = .scaleAspectFill
        avatarView.backgroundColor = UIColor.systemBackground
        avatarView.layer.masksToBounds = true
        avatarView.layer.cornerRadius = wallAvatarWidth/2
        self.contentView.addSubview(avatarView!)
        
        //publisher
        publisher = UILabel(frame: CGRect(x: avatarView.frame.maxX + padding, y: padding, width: ScreenWidth - avatarView.frame.maxY - padding*2, height: publisherHeight))
        publisher?.textColor = UIColor.label
        publisher?.adjustsFontSizeToFitWidth = true
        publisher?.baselineAdjustment = .alignCenters
        publisher?.textAlignment = .left
//        publisher?.font = .boldSystemFont(ofSize: wallAvatarWidth - 15)
        publisher?.font = UIFont.systemFont(ofSize: wallAvatarWidth - 18)
        self.contentView.addSubview(publisher!)
        
        pushdate = UILabel(frame: CGRect(x: avatarView.frame.maxX + padding, y: publisher.frame.maxY + padding/2, width: ScreenWidth - avatarView.frame.maxY - padding*2, height: wallAvatarWidth - padding/2 - publisherHeight))
        pushdate?.textColor = UIColor.secondaryLabel
        pushdate?.font = UIFont.systemFont(ofSize: 12)
        pushdate?.textAlignment = .left
        pushdate?.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(pushdate!)
        
        //poster
        bgView = UIView(frame: CGRect(x: padding, y: avatarView!.frame.maxY + padding, width: ScreenWidth-padding*2, height: (ScreenWidth-padding*2)*wallPosterRatio))
        bgView?.backgroundColor = UIColor.clear
        bgView?.contentMode = .scaleAspectFill
        bgView?.layer.masksToBounds = true
        bgView.layer.cornerRadius = 15
        self.contentView.addSubview(bgView!)
        
        bgImageView = UIImageView(frame: bgView.bounds)
        bgImageView?.contentMode = .scaleAspectFill
//        bgImageView?.layer.cornerRadius = 15
//        bgImageView?.layer.masksToBounds = true
        bgImageView?.contentMode = .scaleAspectFill
        bgView?.addSubview(bgImageView!)
        
        //brief
        titleLabel = UILabel(frame: CGRect(x: padding, y: bgView.bounds.height - padding - briefLabelHeight, width: briefLabelWidth, height: briefLabelHeight))
        titleLabel?.textColor = UIColor.white
        titleLabel?.numberOfLines = 0
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: briefFontSize)
        bgView?.addSubview(titleLabel!)
        
        
        
    }
    
    
    
    func setValueForCell(model:PosterModel){
        let avatarUrlStr = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/profile/avatar/thumbnail/" + String(model.user_id) + "@" + String(model.user_avatar) + ".jpg"
        self.avatarView?.sd_setImage(with: URL(string: avatarUrlStr)!, placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .allowInvalidSSLCertificates], context: nil, progress: nil, completed: nil)
        
        self.publisher?.text = model.user_nickname
        self.titleLabel?.text = model.brief
        
        let posterUrlStr = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/wall/poster/" + String(model.notification_id) + ".jpg"
        
        self.bgImageView?.sd_setImage(with: URL(string: posterUrlStr)!, placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .allowInvalidSSLCertificates], context: nil, progress: nil, completed: nil)
        self.pushdate?.text = model.create_date
    }
    
}
