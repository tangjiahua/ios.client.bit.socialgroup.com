//
//  DiscoverTableViewCell.swift
//  Mask
//
//  Created by 汤佳桦 on 2019/12/14.
//  Copyright © 2019 Beijing Institute of Technology. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    
    override var frame:CGRect{
        get{
            return super.frame
        }
        set{
            var frame = newValue
            frame.origin.x += 5
            frame.origin.y += 10
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
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if(highlighted){
            self.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
//            self.backgroundView?.alpha = 0.2/
        }else{
            self.backgroundColor = .tertiarySystemBackground
        }
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews(){
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.textLabel?.font = .boldSystemFont(ofSize: 18)
        self.textLabel?.textColor = .label
        self.selectionStyle = .none
        
    }
}
