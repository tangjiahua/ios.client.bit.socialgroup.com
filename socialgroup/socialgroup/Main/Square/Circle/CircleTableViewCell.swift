//
//  CircleTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/23.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol CircleTableViewCellDelegate:NSObjectProtocol {
    func avatarTappedCircle(item: CircleItem)
    func likeButtonTappedCircle(item:CircleItem)
    func commentButtonTappedCircle(item:CircleItem)
    func moreButtonTappedCircle(item:CircleItem)
}

class CircleTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var item:CircleItem!
    
    var avatarImageView:UIImageView!
    var nicknameLabel:UILabel!
    var dateLabel:UILabel!
    var contentLabel:UILabel!
    var collectionView:UICollectionView!
    var singleImageView:UIImageView!
    var interactionView:UIView!
    var likeButton:UIButton!
    var likeCountLabel:UILabel!
    var commentButton:UIButton!
    var commentCountLabel:UILabel!
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
    let avatarImageViewHeight:CGFloat = 40
    let nicknameLabelHeight:CGFloat = 20
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
    
    var delegate:CircleTableViewCellDelegate?
    
    
    // MARK:- Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initUI(item:CircleItem){
        self.originImageViews.removeAll()
        self.imageUrls.removeAll()
        
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
        nicknameLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + padding, y: padding, width: ScreenWidth - padding*2 - cellInitPadding - avatarImageViewHeight - padding, height: nicknameLabelHeight))
        nicknameLabel.font = .systemFont(ofSize: nicknameLabelHeight)
        nicknameLabel.text = item.user_nickname
        self.addSubview(nicknameLabel)
        
        // date
        dateLabel = UILabel(frame: CGRect(x: avatarImageView.frame.maxX + padding, y: nicknameLabel.frame.maxY + padding/2, width: ScreenWidth - padding*2 - cellInitPadding - avatarImageViewHeight - padding, height: dateLabelHeight))
        dateLabel.font = .systemFont(ofSize: dateLabelHeight)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .systemGray
        dateLabel.text = item.create_date
        self.addSubview(dateLabel)
        
        // content
        contentLabel = UILabel(frame: CGRect(x: padding, y: avatarImageView.frame.maxY + padding, width: ScreenWidth - padding*2 - cellInitPadding, height: UIDevice.getLabHeigh(labelStr: item.content, font: .systemFont(ofSize: contentLabelFontSize), width: self.bounds.width - padding*2)))
        contentLabel.font = .systemFont(ofSize: contentLabelFontSize)
        contentLabel.numberOfLines = 0
        contentLabel.text = item.content
        self.addSubview(contentLabel)
        
        
        // photos
        if(item.picture_count == 1){
            // 一张照片，放一个正方形的imageView即可
            singleImageView = UIImageView(frame: CGRect(x: padding, y: contentLabel.frame.maxY + padding, width: singleImageViewHeight - cellInitPadding, height: singleImageViewHeight))
            let imageUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/circle/thumbnail/" + String(item.circle_id) + "@1.jpg"
            singleImageView.contentMode = .scaleAspectFill
            singleImageView.layer.cornerRadius = 5
            singleImageView.layer.masksToBounds = true
            singleImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .allowInvalidSSLCertificates], context: nil, progress: nil, completed: nil)
            self.addSubview(singleImageView)
            
            // image tap gesture
            singleImageView.isUserInteractionEnabled = true
            let singleImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleImageTapped))
            singleImageView.addGestureRecognizer(singleImageTapGestureRecognizer)
            self.originImageViews.append(singleImageView)
            self.addSubview(singleImageView)
            
            // 为了调用imageBrowser
            let picUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/circle/picture/" + String(item.circle_id) + "@1.jpg"
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
                collectionViewHeight = collectionViewItemHeight + padding
            }else if(item.picture_count <= 6){
                collectionViewHeight = collectionViewItemHeight*2 + padding*2
            }else{
                collectionViewHeight = collectionViewItemHeight*3 + padding*3
            }
            
            //collectionView
            collectionView = UICollectionView(frame: CGRect(x: padding, y: contentLabel.frame.maxY + padding, width: ScreenWidth - padding*2 - cellInitPadding, height: collectionViewHeight), collectionViewLayout: layout)
            collectionView.backgroundColor = .tertiarySystemBackground
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
            collectionView.isScrollEnabled = false
            
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
        let interactionItemWidth = interactionView.frame.width / 3
        
        // like
            likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: interactionButtonHeight, height: interactionButtonHeight))
            if(item.isLiked){
                likeButton.setImage(UIImage(named: "square-like-fill"), for: .normal)
            }else{
                likeButton.setImage(UIImage(named: "square-like"), for: .normal)
            }
            likeButton.imageView?.contentMode = .scaleAspectFill
            interactionView.addSubview(likeButton)
            
            likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
            
                likeCountLabel = InteractionLabel(frame: CGRect(x: likeButton.frame.maxX, y: 0, width: interactionItemWidth - interactionButtonHeight, height: interactionCountLabelHeight))
                if(item.like_count != 0){
                    likeCountLabel.text = String(item.like_count)
                }
            
                likeCountLabel.font = .systemFont(ofSize: interactionCountLabelFontSize, weight: .light)
                likeCountLabel.textColor = .systemGray
                likeCountLabel.isUserInteractionEnabled = true
                let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeButtonTapped))
                likeCountLabel.addGestureRecognizer(likeTapGestureRecognizer)

                interactionView.addSubview(likeCountLabel)
            
            
            // comment
            commentButton = UIButton(frame: CGRect(x: interactionItemWidth, y: 0, width: interactionButtonHeight, height: interactionButtonHeight))
            commentButton.setImage(UIImage(named: "square-comment"), for: .normal)
            commentButton.imageView?.contentMode = .scaleAspectFill
            interactionView.addSubview(commentButton)
            
            commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
            
            
                commentCountLabel = InteractionLabel(frame: CGRect(x: commentButton.frame.maxX, y: 0, width: interactionItemWidth - interactionButtonHeight, height: interactionCountLabelHeight))
                if(item.comment_count != 0){
                    commentCountLabel.text = String(item.comment_count)
                }
                
                commentCountLabel.font = .systemFont(ofSize: interactionCountLabelFontSize, weight: .light)
                commentCountLabel.textColor = .systemGray
                commentCountLabel.isUserInteractionEnabled = true
                let commentTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentButtonTapped))
                commentCountLabel.addGestureRecognizer(commentTapGestureRecognizer)

                interactionView.addSubview(commentCountLabel)
        
        
         // more
               moreButton = InteractionButton(frame: CGRect(x: interactionItemWidth*2, y: 0, width: interactionItemWidth, height: interactionButtonHeight))
               moreButton.setImage(UIImage(named: "square-more"), for: .normal)
               moreButton.imageView?.contentMode = .scaleAspectFill
               moreButton.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: interactionItemWidth - interactionButtonHeight)
               interactionView.addSubview(moreButton)
               
               moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        for view in interactionView.subviews{
            view.alpha = 0.7
        }
        
    }
    
    
    // MARK:- avatar tapped
    @objc func avatarTapped(){
        self.delegate?.avatarTappedCircle(item: item)
    }
    
}

extension CircleTableViewCell{
    
    // MARK:- CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.picture_count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        let picThumbnailUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/circle/thumbnail/" + String(item.circle_id) + "@" + String(indexPath.row + 1) + ".jpg"
        
        let picUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + UserDefaultsManager.getSocialGroupId() + "/square/circle/picture/" + String(item.circle_id) + "@" + String(indexPath.row + 1) + ".jpg"
        imageView.sd_setImage(with: URL(string: picThumbnailUrl)!, placeholderImage: UIImage(named: "placeholder"), options: [.refreshCached, .allowInvalidSSLCertificates])
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        originImageViews.append(imageView)
        imageUrls.append(picUrl)
        
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        imageTapped(indexPath.row)
        
    }
    
    // MARK:- 点击查看大图
    func imageTapped(_ imageNum:Int){
        print(imageNum)
        let imageBrowserManager = ImageBrowserManager()
        let tableview = self.superview as! UITableView
        let controller = tableview.dataSource as! UIViewController
        imageBrowserManager.imageBrowserManagerWithUrlStr(imageUrls:self.imageUrls, originalImageViews: self.originImageViews, controller: controller, titles: [])
        imageBrowserManager.selectPage = imageNum
        imageBrowserManager.showImageBrowser()
        }
    
    @objc func singleImageTapped(){
        imageTapped(0)
    }
    
    
    // MARK:- Interaction Buttons Actions
    @objc func likeButtonTapped(){
        
        delegate?.likeButtonTappedCircle(item: item)
    }
    
    @objc func commentButtonTapped(){
        delegate?.commentButtonTappedCircle(item: item)
    }
    
    
    @objc func moreButtonTapped(){
        delegate?.moreButtonTappedCircle(item: item)
    }
    
    
}

