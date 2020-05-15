//
//  PushMessageTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/16.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class PushMessageTableViewCell: UITableViewCell {
    
    
    //  1评论 2回复 3戳一戳
    //
    //
    var type:Int?
    var title:String?
    var content:String?
    var addition:String?
    var date:String?
    
    //view
    var titleLabel:UILabel?
    var contentLabel:UILabel?
    var tapLabel:UILabel?
    var dateLabel:UILabel?
    
    
    let cellInitPadding:CGFloat = 10
    let padding:CGFloat = 10
    let titleLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    
    // model
    var model:PushMessageModel?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func initUI(model: PushMessageModel){
        
        self.model = model
        
        self.selectionStyle = .none
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.layer.masksToBounds = true
        
        dateLabel = UILabel(frame: CGRect(x: padding, y: padding, width:  ScreenWidth - padding*2 - 10, height: dateLabelHeight))
        dateLabel?.font = .systemFont(ofSize: dateLabelHeight + 2)
        dateLabel?.textColor = .gray
        dateLabel?.text = model.create_date
        dateLabel?.textAlignment = .center
        self.addSubview(dateLabel!)
        
        
        titleLabel = UILabel(frame: CGRect(x: padding, y: dateLabel!.frame.maxY + padding, width: ScreenWidth - padding*2 - 10, height: titleLabelHeight))
        titleLabel?.font = .boldSystemFont(ofSize: titleLabelHeight)
        self.addSubview(titleLabel!)
        
        
        tapLabel = UILabel(frame: CGRect(x: padding, y: titleLabel!.frame.maxY + padding, width: ScreenWidth - padding*2 - 10, height: titleLabelHeight))
        tapLabel?.font = .systemFont(ofSize: contentLabelFontSize)
        if(model.is_checked){
            tapLabel?.textColor = .gray
        }else{
            tapLabel?.textColor = .systemBlue
        }
        
        tapLabel?.text = "点击查看"
        self.addSubview(tapLabel!)
        
        // 如果是戳一戳，要有contentLabel
        if(model.type == 3){
            let str = "现在您可以查看对方的私密介绍了，如果您再回戳TA，那么TA也会收到提醒并能够查看您的私密介绍"
            contentLabel = UILabel(frame: CGRect(x: padding, y: tapLabel!.frame.maxY + padding, width: ScreenWidth - padding*2 - 10, height: UIDevice.getLabHeigh(labelStr: str, font: .systemFont(ofSize: contentLabelFontSize), width: ScreenWidth - padding*2 - 10)))
            contentLabel?.font = .systemFont(ofSize: contentLabelFontSize)
            contentLabel?.numberOfLines = 0
            contentLabel?.text = str
            self.addSubview(contentLabel!)
        }
        
        
        
        if(model.type == 1){
            // 评论
            titleLabel?.text = "您有一条新评论"
        }else if (model.type == 2){
            // 回复
            titleLabel?.text = "您有一条新回复"
        }else if(model.type == 3){
            // 戳一戳
            titleLabel?.text = "有人戳了你一下"
        }
        
    }

}
