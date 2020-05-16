//
//  SquareReplyTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol SquareReplyTableViewCellDelegate:NSObjectProtocol {
    func avatarTappedReply(item:SquareReplyItem)
    func cellTappedReply(item: SquareReplyItem)
    func replyToUserTappedReply(item: SquareReplyItem)
}

class SquareReplyTableViewCell: UITableViewCell {
    
    var delegate:SquareReplyTableViewCellDelegate!

    //view
    var avatarImageView:UIImageView!
    var nicknameLabel:UILabel!
    var dateLabel:UILabel!
    var contentLabel:UILabel!
    var replyContentLabel:UILabel!
    
    //CGFloat
    override var frame:CGRect{
        get{
            return super.frame
        }
        set{
            var frame = newValue
            frame.origin.x += 5
            frame.origin.y += 5
            frame.size.width -= 2*5
            frame.size.height -= 2*5
            super.frame = frame
        }
    }
    let cellInitPadding:CGFloat = 10
    let padding:CGFloat = 10
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    
    var item:SquareReplyItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initUI(item:SquareReplyItem){
        self.item = item
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.layer.masksToBounds = true
        
        // avatar
        avatarImageView = UIImageView(frame: CGRect(x: padding, y: padding, width: avatarImageViewHeight, height: avatarImageViewHeight))
        let avatarUrlStr = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/profile/avatar/thumbnail/" + item.reply_from_user_id + "@" + item.avatar + ".jpg"
        avatarImageView.sd_setImage(with: URL(string: avatarUrlStr), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .allowInvalidSSLCertificates], context: nil, progress: nil, completed: nil)
        avatarImageView.layer.cornerRadius = avatarImageViewHeight/2
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.masksToBounds = true
        self.addSubview(avatarImageView)
        
        let avatarTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTapGestureRecognizer)
        
        // nickname
        nicknameLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + padding, y: padding, width: ScreenWidth - padding*2 - cellInitPadding - avatarImageViewHeight - padding, height: nicknameLabelHeight))
        nicknameLabel.font = .systemFont(ofSize: nicknameLabelHeight)
        nicknameLabel.text = item.nickname
        self.addSubview(nicknameLabel)
        
        // date
        dateLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + padding, y: nicknameLabel.frame.maxY + padding/2, width: ScreenWidth - padding*2 - cellInitPadding - avatarImageViewHeight - padding, height: dateLabelHeight))
        dateLabel.font = .systemFont(ofSize: dateLabelHeight)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .systemGray
        dateLabel.text = item.create_date
        self.addSubview(dateLabel)
        
        // content
        
        

        
        
        contentLabel = UILabel(frame: CGRect(x: padding, y: avatarImageView.frame.maxY + padding, width: ScreenWidth - padding*2 - 10, height: UIDevice.getLabHeigh(labelStr: "回复 " + item.reply_to_user_nickname + " :  ", font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2 - 10)))
        contentLabel.font = .systemFont(ofSize: contentLabelFontSize)
        contentLabel.numberOfLines = 0
            
        // 富文本
        let text = "回复 " + item.reply_to_user_nickname + " :  "  as NSString
        let highlightText = item.reply_to_user_nickname as NSString
        let hightlightTextRange = text.range(of: highlightText as String)
        let attributeStr = NSMutableAttributedString.init(string: text as String)
        attributeStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: hightlightTextRange)
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.attributedText = attributeStr
        contentLabel.isUserInteractionEnabled = true
        
        
        self.addSubview(contentLabel)
        
        // replyContent
        replyContentLabel = UILabel(frame: CGRect(x: padding, y: contentLabel.frame.maxY + padding, width: ScreenWidth - padding*2 - 10, height: UIDevice.getLabHeigh(labelStr: item.content, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2 - 10)))
        replyContentLabel.font = .systemFont(ofSize: contentLabelFontSize)
        replyContentLabel.numberOfLines = 0
        replyContentLabel.text = item.content
        self.addSubview(replyContentLabel)
        
        
        
        
        
        let replyToUserLabelTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(replyToUserLabelTapped))
        contentLabel.addGestureRecognizer(replyToUserLabelTappedGestureRecognizer)
        
        
        let cellTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedReply))
        self.addGestureRecognizer(cellTappedGestureRecognizer)
        
    }
    
    @objc func avatarTapped(){
        self.delegate?.avatarTappedReply(item: item)
    }
    
    @objc func cellTappedReply(){
        self.delegate.cellTappedReply(item: item)
    }
    
    @objc func replyToUserLabelTapped(){
        self.delegate.replyToUserTappedReply(item: item)
    }

}
