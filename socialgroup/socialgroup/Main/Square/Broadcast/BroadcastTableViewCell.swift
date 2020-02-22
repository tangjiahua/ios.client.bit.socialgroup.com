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
    
    let padding:CGFloat = 10
    let titleLabelHeight:CGFloat = 20
    let dateLabelHeight:CGFloat = 10
    let contentLabelFontSize:CGFloat = 16
    var collectionViewItemHeight:CGFloat{
        return (self.bounds.width - padding*2) / 3 - 3
    }
    
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
        titleLabel = UILabel(frame: CGRect(x: padding, y: padding, width: self.bounds.width - padding*2, height: titleLabelHeight))
        titleLabel.font = .boldSystemFont(ofSize: titleLabelHeight)
        titleLabel.text = item.title
        self.addSubview(titleLabel)
        
        //date
        dateLabel = UILabel(frame: CGRect(x: padding, y: titleLabel.frame.maxY + padding, width: self.bounds.width - padding*2, height: dateLabelHeight))
        dateLabel.font = .systemFont(ofSize: dateLabelHeight)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .systemGray
        dateLabel.text = item.create_date
        self.addSubview(dateLabel)
        
        // content
        contentLabel = UILabel(frame: CGRect(x: padding, y: dateLabel.frame.maxY + padding, width: self.bounds.width - padding*2, height: UIDevice.getLabHeigh(labelStr: item.content, font: .systemFont(ofSize: contentLabelFontSize), width: self.bounds.width - padding*2)))
        contentLabel.font = .systemFont(ofSize: contentLabelFontSize)
        contentLabel.numberOfLines = 0
        contentLabel.text = item.content
        self.addSubview(contentLabel)
        
        
        // photos
        if(item.picture_count == 1){
            // 一张照片，放一个正方形的imageView即可
            singleImageView = UIImageView(frame: CGRect(x: padding, y: contentLabel.frame.maxY + padding, width: self.bounds.width - padding*2, height: self.bounds.width - padding*2))
            let imageUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/broadcast/thumbnail/" + String(item.broadcast_id) + "@1.jpg"
            singleImageView.contentMode = .scaleAspectFill
            singleImageView.layer.cornerRadius = 5
            singleImageView.layer.masksToBounds = true
            singleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"), options: .refreshCached, context: nil, progress: nil, completed: nil)
            self.addSubview(singleImageView)
        } else if(item.picture_count > 1){
            
            // layout
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: collectionViewItemHeight, height: collectionViewItemHeight)
            layout.scrollDirection = .vertical
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
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
            collectionView = UICollectionView(frame: CGRect(x: 0, y: contentLabel.frame.maxY + padding, width: self.bounds.width, height: collectionViewHeight), collectionViewLayout: layout)
            collectionView.backgroundColor = .tertiarySystemBackground
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
            
            self.addSubview(collectionView)
            
            
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
