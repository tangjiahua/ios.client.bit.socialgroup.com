//
//  BroadcastTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/22.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import SDWebImage

protocol BroadcastTableViewCellDelegate:NSObjectProtocol {
    
}

class BroadcastTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var item:BroadcastItem!
    
    var titleLabel:UILabel!
    var dateLabel:UILabel!
    var contentLabel:UILabel!
    var collectionView:UICollectionView!
    var singleImageView:UIImageView!
    var interactionView:UIView!
    var likeButton:UIButton!
    var likeCountLabel:UILabel!
    var commentButton:UIButton!
    var commentCountLabel:UILabel!
    var dislikeButton:UIButton!
    var dislikeCountLabel:UILabel!
    var moreButton:UIButton!
    
    
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
    let titleLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    let singleImageViewHeight:CGFloat = UIDevice.SCREEN_WIDTH*2/3
    var collectionViewItemHeight:CGFloat{
        return (ScreenWidth - padding*2 - cellInitPadding) / 3 - 3
    }
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    let interactionHeight:CGFloat = 25
    let interactionButtonHeight:CGFloat = 25
    let interactionCountLabelHeight:CGFloat = 25
    let interactionCountLabelFontSize:CGFloat = 12
    
    
    
    
    
    var originImageViews:[UIImageView] = []
    var imageUrls:[String] = []
    
    var delegate:BroadcastTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initUI(item:BroadcastItem){
        self.item = item
        
        self.backgroundColor = .tertiarySystemBackground
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        self.layer.masksToBounds = true
        
        
        //titleLabel
        titleLabel = UILabel(frame: CGRect(x: padding, y: padding, width: ScreenWidth - padding*2 - cellInitPadding, height: titleLabelHeight))
        titleLabel.font = .boldSystemFont(ofSize: titleLabelHeight)
        titleLabel.text = item.title
        self.addSubview(titleLabel)
        
        //date
        dateLabel = UILabel(frame: CGRect(x: padding, y: titleLabel.frame.maxY + padding, width: ScreenWidth - padding*2 - cellInitPadding, height: dateLabelHeight))
        dateLabel.font = .systemFont(ofSize: dateLabelHeight)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .systemGray
        dateLabel.text = item.create_date
        self.addSubview(dateLabel)
        
        // content
        contentLabel = UILabel(frame: CGRect(x: padding, y: dateLabel.frame.maxY + padding, width: ScreenWidth - padding*2 - cellInitPadding, height: UIDevice.getLabHeigh(labelStr: item.content, font: .systemFont(ofSize: contentLabelFontSize), width: self.bounds.width - padding*2)))
        contentLabel.font = .systemFont(ofSize: contentLabelFontSize)
        contentLabel.numberOfLines = 0
        contentLabel.text = item.content
        self.addSubview(contentLabel)
        
        
        
        // photos
        if(item.picture_count == 1){
            // 一张照片，放一个正方形的imageView即可
            singleImageView = UIImageView(frame: CGRect(x: padding, y: contentLabel.frame.maxY + padding, width: singleImageViewHeight - cellInitPadding, height: singleImageViewHeight))
            let imageUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/broadcast/thumbnail/" + String(item.broadcast_id) + "@1.jpg"
            singleImageView.contentMode = .scaleAspectFill
            singleImageView.layer.cornerRadius = 5
            singleImageView.layer.masksToBounds = true
            singleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached, context: nil, progress: nil, completed: nil)
            self.addSubview(singleImageView)
            
            
            // 为了调用imageBrowser
            let picUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/broadcast/picture/" + String(item.broadcast_id) + "@1.jpg"
            imageUrls.append(picUrl)
            
        } else if(item.picture_count > 1){
            
            // layout
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: collectionViewItemHeight, height: collectionViewItemHeight)
            layout.scrollDirection = .vertical
            layout.sectionInset = .init(top: padding, left: 0, bottom: padding, right: 0)
            layout.minimumLineSpacing = 6
            layout.minimumInteritemSpacing = 3
            
            // collectionView Height
            var collectionViewHeight:CGFloat
            if(item.picture_count <= 3){
                collectionViewHeight = collectionViewItemHeight + padding*2
            }else if(item.picture_count <= 6){
                collectionViewHeight = collectionViewItemHeight*2 + padding*2
            }else{
                collectionViewHeight = collectionViewItemHeight*3 + padding*2
            }
            
            //collectionView
            collectionView = UICollectionView(frame: CGRect(x: padding, y: contentLabel.frame.maxY + padding, width: ScreenWidth - padding*2 - cellInitPadding, height: collectionViewHeight), collectionViewLayout: layout)
            collectionView.backgroundColor = .tertiarySystemBackground
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
            
            self.addSubview(collectionView)
            
            
        }
        
        // MARK:- Interaction Buttons
        
        // separater line
        var separater_y:CGFloat = 0
        if(item.picture_count == 0){
            separater_y = contentLabel.frame.maxY + padding
        }else if(item.picture_count == 1){
            separater_y = singleImageView.frame.maxY + padding
        }else{
            separater_y = collectionView.frame.maxY + padding
        }
        let separater = UIView(frame: CGRect(x: padding, y: separater_y, width: ScreenWidth - padding*2 - cellInitPadding, height: 1))
        separater.backgroundColor = .darkGray
        separater.alpha = 0.1
        self.addSubview(separater)
        
        // total view
        interactionView = UIView(frame: CGRect(x: padding, y: separater.frame.maxY + padding, width: ScreenWidth - padding*2 - cellInitPadding, height: interactionHeight))
        self.addSubview(interactionView)
        let interactionItemWidth = interactionView.frame.width / 4
        
        // like
        likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: interactionButtonHeight, height: interactionButtonHeight))
        if(item.isLiked){
            likeButton.setImage(UIImage(named: "square-like-fill"), for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "square-like"), for: .normal)
        }
        likeButton.imageView?.contentMode = .scaleAspectFill
        interactionView.addSubview(likeButton)
    
        if(item.like_count != 0){
            likeCountLabel = UILabel(frame: CGRect(x: likeButton.frame.maxX + padding, y: 0, width: interactionItemWidth - interactionButtonHeight - padding, height: interactionCountLabelHeight))
            likeCountLabel.text = String(item.like_count)
            likeCountLabel.font = .systemFont(ofSize: interactionCountLabelFontSize, weight: .light)
            likeCountLabel.textColor = .systemGray

            interactionView.addSubview(likeCountLabel)
        }
        
        // comment
        commentButton = UIButton(frame: CGRect(x: interactionItemWidth, y: 0, width: interactionButtonHeight, height: interactionButtonHeight))
        commentButton.setImage(UIImage(named: "square-comment"), for: .normal)
        commentButton.imageView?.contentMode = .scaleAspectFill
        interactionView.addSubview(commentButton)
        if(item.comment_count != 0){
            commentCountLabel = UILabel(frame: CGRect(x: commentButton.frame.maxX + padding, y: 0, width: interactionItemWidth - interactionButtonHeight - padding, height: interactionCountLabelHeight))
            commentCountLabel.text = String(item.comment_count)
            commentCountLabel.font = .systemFont(ofSize: interactionCountLabelFontSize, weight: .light)
            commentCountLabel.textColor = .systemGray

            interactionView.addSubview(commentCountLabel)
        }
        
        
        
        // dislike
        dislikeButton = UIButton(frame: CGRect(x: interactionItemWidth*2, y: 0, width: interactionButtonHeight, height: interactionButtonHeight))
        if(item.isDisliked){
            dislikeButton.setImage(UIImage(named: "square-dislike-fill"), for: .normal)
        }else{
            dislikeButton.setImage(UIImage(named: "square-dislike"), for: .normal)
        }
        dislikeButton.imageView?.contentMode = .scaleAspectFill
        interactionView.addSubview(dislikeButton)
        
        if(item.dislike_count != 0){
            dislikeCountLabel = UILabel(frame: CGRect(x: dislikeButton.frame.maxX + padding, y: 0, width: interactionItemWidth - interactionButtonHeight - padding, height: interactionCountLabelHeight))
            dislikeCountLabel.text = String(item.dislike_count)
            dislikeCountLabel.font = .systemFont(ofSize: interactionCountLabelFontSize, weight: .light)
            dislikeCountLabel.textColor = .systemGray
            interactionView.addSubview(dislikeCountLabel)
        }
        
        // more
        moreButton = UIButton(frame: CGRect(x: interactionItemWidth*3, y: 0, width: interactionButtonHeight, height: interactionButtonHeight))
        moreButton.setImage(UIImage(named: "square-more"), for: .normal)
        moreButton.imageView?.contentMode = .scaleAspectFill
        interactionView.addSubview(moreButton)
        
        for view in interactionView.subviews{
            view.alpha = 0.7
        }
    }

}


extension BroadcastTableViewCell{
    
    // MARK:- CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.picture_count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        let picThumbnailUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/broadcast/thumbnail/" + String(item.broadcast_id) + "@" + String(indexPath.row + 1) + ".jpg"
        
        let picUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/broadcast/picture/" + String(item.broadcast_id) + "@" + String(indexPath.row + 1) + ".jpg"
        imageView.sd_setImage(with: URL(string: picThumbnailUrl)!, placeholderImage: UIImage(named: "placeholder"), options: .refreshCached)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        originImageViews.append(imageView)
        imageUrls.append(picUrl)
        
        
        cell.addSubview(imageView)
        
        return cell
    }
}
