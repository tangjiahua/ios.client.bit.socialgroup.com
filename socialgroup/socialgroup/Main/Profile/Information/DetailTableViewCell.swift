//
//  DetailTableViewCell.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //ui
    let screenWidth = UIDevice.SCREEN_WIDTH
    let screenHeight = UIDevice.SCREEN_HEIGHT
    let nicknameFontSize:CGFloat = 30
    let nicknameLabelHeight:CGFloat = 30
    let realnameLabelHeight:CGFloat = 18
//    let shortDetailInfoLabelHeight:CGFloat = 20
    let publicIntroductionLabelFontSize:CGFloat = 20
    let publicIntroductionLabelHeight:CGFloat = 20
    let publicIntroductionTextViewFonrSize:CGFloat = 16
    let publicIntroductionLabelMinimunHeight:CGFloat = 100
    let padding:CGFloat = 15
    let smallpadding:CGFloat = 5
    
    var itemHeight:CGFloat{
        return (screenWidth - padding * 4) / 3
    }
    
    
    
    //model
    var profileModel:ProfileModel!
    
    
    // uikit
    var nicknameLabel: UILabel!
    var realnameAndgenderAndageLabel: UILabel!
    //tableview
    var particularInfoTableView:UITableView!
    //collectionview
    var wallCollectionView: UICollectionView!
    let identifier = "CollectionViewCell"
    var gradeLabel:UILabel!
    var homewtownLabel:UILabel!
    var majorLabel:UILabel!
    var relationshipStatusLabel:UILabel!
    var publicIntroductionTextView:UITextView!
    var privateIntroductionTextView:UITextView!
    
    
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
        realnameAndgenderAndageLabel.text = "@" + profileModel.realname + "  " + profileModel.gender + "  " + profileModel.age
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
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: smallpadding, left: padding, bottom: smallpadding, right: padding)
        layout.minimumLineSpacing = padding
        
        wallCollectionView = UICollectionView(frame: CGRect(x: 0, y: particularInfoTableView.frame.maxY + padding, width: screenWidth, height: itemHeight * 2 + padding*2), collectionViewLayout: layout)
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
        
        
        var publicIntroductionTextViewHeight = UIDevice.getLabHeigh(labelStr: profileModel.publicIntroduce, font: .systemFont(ofSize: publicIntroductionTextViewFonrSize), width: screenWidth - padding*2)
        if(publicIntroductionTextViewHeight < publicIntroductionLabelMinimunHeight){
            publicIntroductionTextViewHeight = publicIntroductionLabelMinimunHeight
        }
        publicIntroductionTextView = UITextView(frame: CGRect(x: padding, y: publicIntroductionLabel.frame.maxY + padding, width: screenWidth - 2*padding, height: publicIntroductionTextViewHeight + 20))
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
            
            var privateIntroductionTextViewHeight = UIDevice.getLabHeigh(labelStr: profileModel.privateIntroduce, font: .systemFont(ofSize: publicIntroductionTextViewFonrSize), width: screenWidth - padding*2)
            if(privateIntroductionTextViewHeight < publicIntroductionLabelMinimunHeight){
                privateIntroductionTextViewHeight = publicIntroductionLabelMinimunHeight
            }
            privateIntroductionTextView = UITextView(frame: CGRect(x: padding, y: privateIntroductionLabel.frame.maxY + padding, width: screenWidth - 2*padding, height: privateIntroductionTextViewHeight + 20))
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wallCollectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        cell.addSubview(imageView)
        
        return cell
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
            cell.textLabel?.text = space + "重庆"
            icon.image = UIImage(named:"hometown")
        case 1:
            cell.textLabel?.text = space + "2017"
            icon.image = UIImage(named:"grade")


        case 2:
            cell.textLabel?.text = space + "恋爱中"
            icon.image = UIImage(named:"love")


        case 3:
            cell.textLabel?.text = space + "计算机科学与技术"
            icon.image = UIImage(named:"major")

            
        default:
            return cell
        }
        return cell
    }
}
