//
//  EditWallViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import Photos

class EditWallViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyProfileModelDelegate {
    
    
    
    var profileModel:ProfileModel!
    
    var collectionView:UICollectionView!
    
    var toolBar:UIToolbar!
    
    var seetGridThumbnailSize:CGSize!
    
    let padding:CGFloat = 15
    
    let uploadButtonHeight:CGFloat = 50
    
    let toolBarHeight:CGFloat = 70
    
    let smallpadding:CGFloat = 5
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profileModel.myProfileModelDelegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIDevice.SCREEN_WIDTH - padding*2)/3-3, height: (UIDevice.SCREEN_WIDTH - padding*2)/3-3)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 6
        layout.sectionInset = .init(top: smallpadding, left: padding, bottom: smallpadding, right: padding)
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        view.addSubview(collectionView)
        
        
        
        
        let uploadButton = UIButton(frame: CGRect(x: padding, y: padding, width: UIDevice.SCREEN_WIDTH - padding*2, height: uploadButtonHeight))
        uploadButton.backgroundColor = .systemBlue
        uploadButton.setTitle("上传照片", for: .normal)
        uploadButton.layer.cornerRadius = 5
        uploadButton.layer.masksToBounds = true
        uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIDevice.SCREEN_HEIGHT - toolBarHeight - UIDevice.HEIGHT_OF_ADDITIONAL_FOOTER, width: UIDevice.SCREEN_WIDTH, height: toolBarHeight))
        
        toolBar.addSubview(uploadButton)
        view.addSubview(toolBar)
    }
    
    
    
    @objc func uploadButtonTapped(){
        let maxSelected:Int = 6 - Int(profileModel.wallPhotosCount)!
        if(maxSelected == 0){
            self.showTempAlert(info: "最多只能上传6张照片哦")
            return
        }else{
            _ = self.presentHGImagePicker(maxSelected: maxSelected) { (assets) in
                self.showLoading(text: "正在上传照片墙", isSupportClick: false)

                var datas:[Data] = []
                let imageManager = PHImageManager.default()
                let imageRequesOption = PHImageRequestOptions()
                imageRequesOption.isSynchronous = true
                imageRequesOption.resizeMode = .none
                imageRequesOption.deliveryMode = .highQualityFormat
                
                for asset in assets{
                    print(asset)
                    imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: imageRequesOption) { (result, _) in
                        let data = result!.jpegData(compressionQuality: 0.5)!
                        datas.append(data)
                        if(datas.count == assets.count){
                            self.profileModel.setMyAddWallPhotoToServer(datas: datas)
                            
                        }
                    }
                }
                
                
            }
        }
    }
    

    //MARK:- collection view datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(profileModel.wallPhotosCount)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        
        let picUrl = NetworkManager.SERVER_RESOURCE_URL + "socialgroup_" + profileModel.socialgroup_id + "/profile/wall/thumbnail/" + profileModel.myuserid + "@" + String(indexPath.row + 1) + ".jpg"
        imageView.sd_setImage(with: URL(string: picUrl)!, placeholderImage: UIImage(named: "placeholder"), options: .fromLoaderOnly)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
//        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(indexPath.row)))
//        imageView.addGestureRecognizer(imageTapGestureRecognizer)
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageTapped(indexPath.row)
    }
    
    
    func imageTapped(_ imageNum:Int){
        print(imageNum)
        
        let sheet = UIAlertController.init(title: "选择功能", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(.init(title: "查看原图", style: .default, handler: { (UIAlertAction) in
            print("查看原图")
        }))
        sheet.addAction(.init(title: "删除该图", style: .default, handler: { (UIAlertAction) in
            self.showLoading(text: "正在删除", isSupportClick: false)
            self.profileModel.setMyDeleteWallPhotoToServer(delete: String(imageNum + 1))
        }))
        sheet.addAction(.init(title: "取消", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
    
    
}


extension EditWallViewController{
    func getMyProfileServerSuccess() {
        print("get my profile server success")
        profileModel.setMyProfileModelToLocal()
        collectionView.reloadData()
    }
    
    func getMyProfileServerFail(info: String) {
        
    }
    
    func setMyAvatarToServerSuccess() {
        
    }
    
    func setMyAvatarToServerFail() {
        
    }
    
    func setMyBackgroundToServerSuccess() {
        
    }
    
    func setMyBackgroundToServerFail() {
        
    }
    
    func setMyTextProfileToServerSuccess() {
        
    }
    
    func setMyTextProfileToServerFail() {
        
    }
    
    func setMyAddWallPhotoToServerSuccess() {
        self.hideHUD()
        self.showTempAlert(info: "上传照片墙成功")
        profileModel.getMyProfileModelFromServer()
    }
    
    func setMyAddWallPhotoToServerFail() {
        self.hideHUD()
        self.showTempAlert(info: "上传照片墙失败")
        print("set my add wall photos server fail")
        
    }
    
    func setMyDeleteWallPhotoToServerSuccess() {
        self.hideHUD()
        self.showTempAlert(info: "删除成功")
        profileModel.getMyProfileModelFromServer()
    }
    
    func setMyDeleteWallPhotoToServerFail() {
        self.hideHUD()
        self.showTempAlert(info: "删除失败")
        print("set my add wall photos server fail")
    }
}
