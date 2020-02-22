//
//  DetailTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit


protocol DetailTableViewCellDelegate: NSObjectProtocol {
    func wallPhotoTapped()
}



class DetailTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    //ui
    let screenWidth = UIDevice.SCREEN_WIDTH
    let screenHeight = UIDevice.SCREEN_HEIGHT
    let nicknameFontSize:CGFloat = 30
    let nicknameLabelHeight:CGFloat = 30
    let realnameLabelHeight:CGFloat = 18
    let publicIntroductionLabelFontSize:CGFloat = 20
    let publicIntroductionLabelHeight:CGFloat = 20
    let publicIntroductionTextViewFonrSize:CGFloat = 16
    let publicIntroductionTextViewMinimunHeight:CGFloat = 100
    let padding:CGFloat = 15
    let smallpadding:CGFloat = 5
    let publicIntroductionTextViewHeight:CGFloat = 300
    let privateIntroductionTextViewHeight:CGFloat = 200
    
    var itemHeight:CGFloat{
        return (screenWidth - padding*2) / 3 - 3
    }
    
    
    
    //model
    var profileModel:ProfileModel!
    
    
    // uikit
    var nicknameLabel: UILabel!
    var realnameAndgenderAndageLabel: UILabel!
    //tableview
    var particularInfoTableView:UITableView!
    //collectionview
    var wallLabel:UILabel!
    var wallCollectionView: UICollectionView!
    let identifier = "CollectionViewCell"
    var gradeLabel:UILabel!
    var homewtownLabel:UILabel!
    var majorLabel:UILabel!
    var relationshipStatusLabel:UILabel!
    var publicIntroductionTextView:UITextView!
    var privateIntroductionTextView:UITextView!
    
    //imageBrowser
    var originImageViews:[UIImageView] = []
    var imageUrls:[String] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        
        // Configure the view for the selected state
    }

    
    func setUpUI(_ model: ProfileModel){
        profileModel = model
        
        
        self.backgroundColor = .secondarySystemBackground
        initBasicInformation()
        initParticularInformation()
        initWall()
        initDetailInformation()
        
    }
    
    
    func initBasicInformation(){
        
        nicknameLabel = UILabel(frame: CGRect(x: padding, y: smallpadding, width: screenWidth - padding * 2, height: nicknameLabelHeight))
        nicknameLabel?.text = profileModel?.nickname
        nicknameLabel?.font = .boldSystemFont(ofSize: nicknameFontSize)
        nicknameLabel?.textAlignment = .left
        nicknameLabel?.textColor = .label
        nicknameLabel?.numberOfLines = 1
        self.addSubview(nicknameLabel!)
        
        realnameAndgenderAndageLabel = UILabel(frame: CGRect(x: padding, y: nicknameLabel!.frame.maxY + smallpadding , width: screenWidth - padding * 2, height: realnameLabelHeight))
        var genderSymbol = "♂"
        if(profileModel.gender.equals(str: "f")){
            genderSymbol = "♀"
        }
        realnameAndgenderAndageLabel.text = "@" + profileModel.realname + " · " + genderSymbol + " · " + profileModel.age
        realnameAndgenderAndageLabel.font = .systemFont(ofSize: realnameLabelHeight)
        realnameAndgenderAndageLabel.textAlignment = .left
        realnameAndgenderAndageLabel.textColor = .tertiaryLabel
        realnameAndgenderAndageLabel.numberOfLines = 1
        self.addSubview(realnameAndgenderAndageLabel)
        
    }
    
    func initParticularInformation(){
        particularInfoTableView = UITableView(frame: CGRect(x: 0, y: realnameAndgenderAndageLabel.frame.maxY + padding, width: screenWidth, height: 160), style: .plain)
        particularInfoTableView.dataSource = self
        particularInfoTableView.delegate = self
        self.addSubview(particularInfoTableView)
    }
    
    func initWall(){
        
        //照片墙label
        wallLabel = UILabel(frame: CGRect(x: padding, y: particularInfoTableView.frame.maxY + padding, width: screenWidth, height: publicIntroductionLabelHeight))
        wallLabel.text = "照片墙:"
        wallLabel.font = .boldSystemFont(ofSize: publicIntroductionLabelFontSize)
        self.addSubview(wallLabel)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: smallpadding, left: padding, bottom: smallpadding, right: padding)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 3
        
        var wallCollectionViewHeight:CGFloat
        let count = Int(profileModel.wallPhotosCount)!
        if(count == 0){
            wallCollectionViewHeight = 0
        }else if(count > 0 && count <= 3){
            wallCollectionViewHeight = itemHeight + padding*2
        }else{
            wallCollectionViewHeight = itemHeight*2 + padding*2
        }
        
        wallCollectionView = UICollectionView(frame: CGRect(x: 0, y: wallLabel.frame.maxY + padding, width: screenWidth, height: wallCollectionViewHeight), collectionViewLayout: layout)
        wallCollectionView.backgroundColor = .secondarySystemBackground
        wallCollectionView.delegate = self
        wallCollectionView.dataSource = self
        wallCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        
        
        self.addSubview(wallCollectionView)
        
    }
    
    func initDetailInformation(){
        
        // public intyroducetion
        let publicIntroductionLabel = UILabel(frame: CGRect(x: padding, y: wallCollectionView.frame.maxY + padding, width: screenWidth, height: publicIntroductionLabelHeight))
        publicIntroductionLabel.text = "公开:"
        publicIntroductionLabel.font = .boldSystemFont(ofSize: publicIntroductionLabelFontSize)
        self.addSubview(publicIntroductionLabel)
        
        publicIntroductionTextView = UITextView(frame: CGRect(x: padding, y: publicIntroductionLabel.frame.maxY + padding, width: screenWidth - 2*padding, height: publicIntroductionTextViewHeight))
        publicIntroductionTextView.font = .systemFont(ofSize: publicIntroductionTextViewFonrSize)
        publicIntroductionTextView.text = profileModel.publicIntroduce
        publicIntroductionTextView.textColor = .secondaryLabel
        publicIntroductionTextView.layer.cornerRadius = 5
        publicIntroductionTextView.layer.masksToBounds = true
        publicIntroductionTextView.backgroundColor = .tertiarySystemBackground
        publicIntroductionTextView.isEditable = false
        self.addSubview(publicIntroductionTextView)
        
        
        if(profileModel.isPrivateAbleToSee){
            //private introducetion
            let privateIntroductionLabel = UILabel(frame: CGRect(x: padding, y: publicIntroductionTextView.frame.maxY + padding, width: screenWidth - padding*2, height: publicIntroductionLabelHeight))
            privateIntroductionLabel.text = "私密:"
            privateIntroductionLabel.font = .boldSystemFont(ofSize: publicIntroductionLabelFontSize)
            self.addSubview(privateIntroductionLabel)
            

            privateIntroductionTextView = UITextView(frame: CGRect(x: padding, y: privateIntroductionLabel.frame.maxY + padding, width: screenWidth - 2*padding, height: privateIntroductionTextViewHeight))
            privateIntroductionTextView.font = .systemFont(ofSize: publicIntroductionTextViewFonrSize)
            privateIntroductionTextView.text = profileModel.privateIntroduce
            privateIntroductionTextView.textColor = .secondaryLabel
            privateIntroductionTextView.layer.cornerRadius = 5
            privateIntroductionTextView.layer.masksToBounds = true
            privateIntroductionTextView.backgroundColor = .tertiarySystemBackground
            privateIntroductionTextView.isEditable = false
            self.addSubview(privateIntroductionTextView)
            
            
        }
        
       
        
        
        
    }
    
    
    //MARK:- Wall Photos Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(profileModel.wallPhotosCount)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wallCollectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        
        let picThumbnailUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.socialgroup_id + "/profile/wall/thumbnail/" + profileModel.myuserid + "@" + String(indexPath.row + 1) + ".jpg"
        let picUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.socialgroup_id + "/profile/wall/" + profileModel.myuserid + "@" + String(indexPath.row + 1) + ".jpg"
        imageView.sd_setImage(with: URL(string: picThumbnailUrl)!, placeholderImage: UIImage(named: "placeholder"), options: .refreshCached)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        originImageViews.append(imageView)
        imageUrls.append(picUrl)
        
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        wallImageTapped(indexPath.row)
    }
    
    func wallImageTapped(_ imageNum:Int){
        print(imageNum)
        let imageBrowserManager = ImageBrowserManager()
        let tableview = self.superview as! UITableView
        let controller = tableview.dataSource as! UIViewController
//        controller.tabBarController?.hideTabbar(hidden: true)
        imageBrowserManager.imageBrowserManagerWithUrlStr(imageUrls:self.imageUrls, originalImageViews: self.originImageViews, controller: controller, titles: [])
        imageBrowserManager.selectPage = imageNum
        imageBrowserManager.showImageBrowser()
        
        
    }
    
    
    //MARK:- Particular Information View Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.textColor = .label
        let icon = UIImageView(frame: CGRect(x: padding, y: 5, width: 30, height: 30))
        let space = "        "
        cell.selectionStyle = .none
        
        cell.addSubview(icon)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = space + profileModel.hometown
            icon.image = UIImage(named:"hometown")
        case 1:
            cell.textLabel?.text = space + profileModel.grade
            icon.image = UIImage(named:"grade")


        case 2:
            cell.textLabel?.text = space + profileModel.relationshipStatus
            icon.image = UIImage(named:"love")


        case 3:
            cell.textLabel?.text = space + profileModel.major
            icon.image = UIImage(named:"major")

            
        default:
            return cell
        }
        return cell
    }
}
