//
//  CirclePushViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import Photos

class CirclePushViewController: BasePushViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    var originImageViews:[UIImageView] = [] //查看大图的时候传入的原始的imageView
    var imageUrls:[String] = []
    var photos:[UIImage] = []
    
    var textContent: String = ""
    
    var tableView:UITableView!
    var contentTextView:UITextView!
    var contentTextViewPlaceHolder:UILabel!
    var contentTextViewCountLabel:UILabel!
    var contentTextViewCount:Int!
    var toolBar:UIToolbar!
    var collectionView:UICollectionView!
    var seetGridThumbnailSize:CGSize!
    var finishToolBar:UIToolbar!
    
    
    let ScreenWidth = UIDevice.SCREEN_WIDTH
    let ScreenHeight = UIDevice.SCREEN_HEIGHT
    
    let padding:CGFloat = 5
    let contentFontSize:CGFloat = 18
    let contentTextViewHeight:CGFloat = 200
    let contentTextViewCountLabelHeight:CGFloat = 20
    let contentTextViewCountLabelWidth:CGFloat = 80
    let toolButtonHeight:CGFloat = 35
    let smallpadding:CGFloat = 5
    
    let maxContentCount = 400
    
    let rowHeight : [CGFloat] = [200 + 10 + 10 + 18, 35, UIDevice.SCREEN_WIDTH + 30]
    

    
    // MARK:- functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布动态"
        initUI()
    }
    
    
    func initUI(){
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        
        // hide keyboard
        finishToolBar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButtonAction))
        finishToolBar.setItems([flexSpace, doneBtn], animated: false)
        finishToolBar.sizeToFit()
         
        //对输入框进行设置
       
    }

    // MARK:- actions
    
    @objc func doneButtonAction() {
        contentTextView.resignFirstResponder()
    }
    
    override func pushTapped() {
        if(photos.count != 0){
            // 带图发布
            pushWithPhoto(method: "circle", title: nil, content: textContent, photos: photos)
        }else{
            // 文字发布
            pushWithoutPhoto(method: "circle", title: nil, content: textContent)
        }
    }
    
    func photoTapped(row: Int){
        let alert = UIAlertController.init(title: "提示", message: "是否删除该图", preferredStyle: .alert)
        alert.addAction(.init(title: "确定", style: .default, handler: { (action) in
            self.photos.remove(at: row)
            self.collectionView.reloadData()
        }))
        alert.addAction(.init(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addPictureButtonTapped(){
        print("addphotos")
        let maxSelected:Int = 9 - photos.count
        if(maxSelected == 0){
            self.showTempAlert(info: "最多只能上传9张照片哦")
            return
        }else{
            _ = self.presentHGImagePicker(maxSelected: maxSelected) { (assets) in
                let imageManager = PHImageManager.default()
                let imageRequesOption = PHImageRequestOptions()
                imageRequesOption.isSynchronous = true
                imageRequesOption.resizeMode = .fast
                imageRequesOption.deliveryMode = .highQualityFormat
                
                for asset in assets{
                    imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: imageRequesOption) { (result, _) in
                        self.photos.append(result!)
                    }
                }
                
                self.collectionView.reloadData()
                
            }
        }
    }
    
    @objc func hideKeyBoard(){
        contentTextView.resignFirstResponder()
    }

    
    
    
    // MARK:- tableview datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tablviewnumberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            contentTextView = UITextView(frame: CGRect(x: padding, y: padding, width: ScreenWidth - padding*2, height: contentTextViewHeight))
            contentTextView.font = .systemFont(ofSize: contentFontSize)
            contentTextView.backgroundColor = .secondarySystemBackground
            contentTextView.delegate = self
            contentTextView.text = textContent
            contentTextView.returnKeyType = .default
            contentTextView.inputAccessoryView = finishToolBar
            
            contentTextViewPlaceHolder = UILabel(frame: CGRect(x: 10, y: padding*2, width: ScreenWidth, height: contentFontSize))
            contentTextViewPlaceHolder.textColor = .systemGray
            contentTextViewPlaceHolder.alpha = 0.5
            contentTextViewPlaceHolder.font = .systemFont(ofSize: contentFontSize)
            contentTextViewPlaceHolder.text = "写点什么..."
            contentTextView.addSubview(contentTextViewPlaceHolder)
            
            cell.selectionStyle = .none
            cell.backgroundColor = .secondarySystemBackground
            cell.addSubview(contentTextView)
            
            contentTextViewCountLabel = UILabel(frame: CGRect(x: ScreenWidth - padding - contentTextViewCountLabelWidth, y: contentTextView.frame.maxY + 5, width: contentTextViewCountLabelWidth, height: contentTextViewCountLabelHeight))
            contentTextViewCount = 0
            contentTextViewCountLabel.textColor = .systemGray
            contentTextViewCountLabel.textAlignment = .right
            contentTextViewCountLabel.text = String(contentTextViewCount) + "/\(maxContentCount)"
            cell.addSubview(contentTextViewCountLabel)
            return cell
        }else if(indexPath.row == 1){
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.backgroundColor = .secondarySystemBackground
            cell.selectionStyle = .none
            
            let addPictureButton = UIButton(frame: CGRect(x: 5, y: 0, width: toolButtonHeight, height: toolButtonHeight))
            addPictureButton.setImage(UIImage(named: "picture"), for:  .normal)
            addPictureButton.addTarget(self, action: #selector(addPictureButtonTapped), for: .touchUpInside)
            
            cell.addSubview(addPictureButton)
            
            return cell
        }else if(indexPath.row == 2){
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            
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
            cell.addSubview(collectionView)
            
            return cell
        }
        else{
            return UITableViewCell(style: .default, reuseIdentifier: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight[indexPath.row]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            contentTextView.resignFirstResponder()
        }
    }
}


extension CirclePushViewController{
    // MARK:- text edit delegate
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.count != 0){
            self.contentTextViewPlaceHolder.isHidden = true
        }else{
            self.contentTextViewPlaceHolder.isHidden = false
        }
        contentTextViewCount = contentTextView.text.count
        contentTextViewCountLabel.text = String(contentTextViewCount) + "/\(maxContentCount)"
        textContent = contentTextView.text ?? ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView.text!.count + text.count > maxContentCount){
            return false
        }
        return true
    }
    
    
    
    
    //MARK:- ui collectionVIew data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
        
        for subview in cell.subviews{
            subview.removeFromSuperview()
        }
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.image = photos[indexPath.row]
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoTapped(row: indexPath.row)
    }
}
