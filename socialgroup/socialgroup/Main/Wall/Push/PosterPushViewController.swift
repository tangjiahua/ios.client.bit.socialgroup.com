//
//  PosterPushViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/3/1.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import Alamofire

struct PosterPushModel {
    var posterImagePath:String!
    var welcome:String!
    var holddate:String!
    var holdlocation:String!
    var holder:String!
    var detail:String!
    var link:String!
}

protocol PosterPushViewControllerDelegate:NSObjectProtocol {
    func posterPushSuccess()
}

class PosterPushViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate,UIScrollViewDelegate, NotificationPushManagerDelegate {
    
    var delegate:PosterPushViewControllerDelegate?

    let scrollView = UIScrollView()
    let dismissButton = UIButton()
    let posterStaticLabel = UILabel()
    let posterImageView = UIImageView()
    
    let welcomeStaticLabel = UILabel()
    let welcomeTextView = UITextView()
    let holddateStaticLabel = UILabel()
    let holddateTextField = UITextField()
    let holdlocationStaticLabel = UILabel()
    let holdlocationTextField = UITextField()
    let holderStaticLabel = UILabel()
    let holderTextField = UITextField()
    let detailStaticLabel = UILabel()
    let detailTextView = UITextView()
    let moreStaticLabel = UILabel()
    let moreTextField = UITextField()
    let postButton = UIButton()


    let dismissButtonWidth:CGFloat = 40
    let padding:CGFloat = 18

    let posterWidth:CGFloat = ScreenWidth/3
    let posterRatio:CGFloat = 1.3
    let titleTextFieldHeight:CGFloat = 40
    let welcomeTextViewRatio:CGFloat = 0.7
    let holddateTextFieldHeight:CGFloat = 40
    let holdlocationTextFieldHeight:CGFloat = 40
    let holderTextFieldHeight:CGFloat = 40
    let detailTextViewRatio:CGFloat = 1.2
    let moreTextFieldHeight:CGFloat = 40
    let postButtonWidth:CGFloat = 80

    
    let pushManager = NotificationPushManager()
    var push_api:String?
    
    var posterPushModel = PosterPushModel(posterImagePath: "", welcome: "", holddate: "", holdlocation: "", holder: "", detail: "", link: "")

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pushManager.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        tapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate = nil
    }
    


    func setUpViews(){
        setUpPosterView()
    }

    func setUpPosterView(){
        //base scrollview

        scrollView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        scrollView.contentSize = CGSize(width: ScreenWidth, height: ScreenHeight*2)
        scrollView.backgroundColor = UIColor.secondarySystemBackground
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = true
        self.view.addSubview(scrollView)

        //dismissButton
        dismissButton.frame = CGRect(x: ScreenWidth - dismissButtonWidth - padding, y: padding*3, width: dismissButtonWidth, height: dismissButtonWidth)
        dismissButton.setImage(UIImage(named: "button_cancel"), for: .normal)
        dismissButton.imageView?.contentMode = .scaleAspectFill
        dismissButton.imageView?.layer.masksToBounds = true
        dismissButton.imageView?.layer.cornerRadius = dismissButtonWidth/2
        dismissButton.addTarget(self, action: #selector(dismissButtonClicked), for: .touchUpInside)
        self.view.addSubview(dismissButton)


        //
        let staticLabelHeight:CGFloat = UIDevice.getLabHeigh(labelStr: "默认", font: UIFont.boldSystemFont(ofSize: 30), width: ScreenWidth-padding*2)

        posterStaticLabel.font = UIFont.boldSystemFont(ofSize: 30)
        posterStaticLabel.textColor = UIColor.label
        posterStaticLabel.text = "海报："
        posterStaticLabel.numberOfLines = 1
        posterStaticLabel.frame = CGRect(x: padding, y: padding*3, width: ScreenWidth-padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(posterStaticLabel)

        posterImageView.image = UIImage(named: "swift")
        posterImageView.isUserInteractionEnabled = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.masksToBounds = true
        posterImageView.frame = CGRect(x: ScreenWidth/4, y: posterStaticLabel.frame.maxY + padding, width: ScreenWidth/2, height: (ScreenWidth/2)*posterRatio)
        let posterTapGesture = UITapGestureRecognizer(target: self, action: #selector(posterTapped))
        posterImageView.addGestureRecognizer(posterTapGesture)
        self.scrollView.addSubview(posterImageView)


        

    

        welcomeStaticLabel.font = UIFont.boldSystemFont(ofSize: 30)
        welcomeStaticLabel.textColor = UIColor.label
        welcomeStaticLabel.text = "引语:"
        welcomeStaticLabel.numberOfLines = 1
        welcomeStaticLabel.frame = CGRect(x: padding, y: posterImageView.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(welcomeStaticLabel)

        welcomeTextView.textColor = UIColor.secondaryLabel
        welcomeTextView.font = UIFont(name: "PingFangSC-Light", size: 17)!
        welcomeTextView.backgroundColor = UIColor.tertiarySystemBackground
        welcomeTextView.frame = CGRect(x: padding, y: welcomeStaticLabel.frame.maxY + padding, width: ScreenWidth-padding*2, height: (ScreenWidth-padding*2)*welcomeTextViewRatio)
        welcomeTextView.delegate = self
        self.scrollView.addSubview(welcomeTextView)

        holddateStaticLabel.font = UIFont.boldSystemFont(ofSize: 30)
        holddateStaticLabel.textColor = UIColor.label
        holddateStaticLabel.text = "时间："
        holddateStaticLabel.numberOfLines = 1
        holddateStaticLabel.frame = CGRect(x: padding, y: welcomeTextView.frame.maxY + padding, width: ScreenWidth-padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(holddateStaticLabel)

        holddateTextField.placeholder = "输入举办时间..."
        holddateTextField.textColor = UIColor.secondaryLabel
        holddateTextField.backgroundColor = UIColor.tertiarySystemBackground
        holddateTextField.frame = CGRect(x: padding, y: holddateStaticLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: holddateTextFieldHeight)
        holddateTextField.delegate = self
        self.scrollView.addSubview(holddateTextField)

        holdlocationStaticLabel.font = .boldSystemFont(ofSize: 30)
        holdlocationStaticLabel.textColor = .label
        holdlocationStaticLabel.text = "地点："
        holdlocationStaticLabel.numberOfLines = 1
        holdlocationStaticLabel.frame = CGRect(x: padding, y: holddateTextField.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(holdlocationStaticLabel)

        holdlocationTextField.placeholder = "输入举办地点..."
        holdlocationTextField.textColor = .secondaryLabel
        holdlocationTextField.backgroundColor = .tertiarySystemBackground
        holdlocationTextField.frame = CGRect(x: padding, y: holdlocationStaticLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: holdlocationTextFieldHeight)
        holdlocationTextField.delegate = self
        self.scrollView.addSubview(holdlocationTextField)

        holderStaticLabel.font = .boldSystemFont(ofSize: 30)
        holderStaticLabel.textColor = .label
        holderStaticLabel.text = "举办者："
        holderStaticLabel.numberOfLines = 1
        holderStaticLabel.frame = CGRect(x: padding, y: holdlocationTextField.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(holderStaticLabel)

        holderTextField.placeholder = "输入举办者..."
        holderTextField.textColor = .secondaryLabel
        holderTextField.backgroundColor = .tertiarySystemBackground
        holderTextField.frame = CGRect(x: padding, y: holderStaticLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: holderTextFieldHeight)
        holderTextField.delegate = self
        self.scrollView.addSubview(holderTextField)

        detailStaticLabel.font = .boldSystemFont(ofSize: 30)
        detailStaticLabel.textColor = .label
        detailStaticLabel.numberOfLines = 1
        detailStaticLabel.text = "简介："
        detailStaticLabel.frame = CGRect(x: padding, y: holderTextField.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(detailStaticLabel)

        detailTextView.textColor = UIColor.secondaryLabel
        detailTextView.font = UIFont(name: "PingFangSC-Light", size: 17)!
        detailTextView.backgroundColor = UIColor.tertiarySystemBackground
        detailTextView.frame = CGRect(x: padding, y: detailStaticLabel.frame.maxY + padding, width: ScreenWidth-padding*2, height: (ScreenWidth-padding*2)*detailTextViewRatio)
        detailTextView.delegate = self
        self.scrollView.addSubview(detailTextView)

        moreStaticLabel.font = .boldSystemFont(ofSize: 30)
        moreStaticLabel.textColor = .label
        moreStaticLabel.numberOfLines = 1
        moreStaticLabel.text = "更多信息："
        moreStaticLabel.frame = CGRect(x: padding, y: detailTextView.frame.maxY + padding, width: ScreenWidth - padding*2, height: staticLabelHeight)
        self.scrollView.addSubview(moreStaticLabel)

        moreTextField.placeholder = "粘贴外链到此..."
        moreTextField.textColor = .secondaryLabel
        moreTextField.backgroundColor = .tertiarySystemBackground
        moreTextField.frame = CGRect(x: padding, y: moreStaticLabel.frame.maxY + padding, width: ScreenWidth - padding*2, height: moreTextFieldHeight)
        moreTextField.delegate = self
        self.scrollView.addSubview(moreTextField)

        //post button
        postButton.frame = CGRect(x: (ScreenWidth-postButtonWidth)/2, y: moreTextField.frame.maxY + padding, width: postButtonWidth, height: postButtonWidth)
        postButton.setImage(UIImage(named: "post_button"), for: .normal)
        postButton.imageView?.contentMode = .scaleAspectFill
        postButton.addTarget(self, action: #selector(pushPoster), for: .touchUpInside)
        self.scrollView.addSubview(postButton)


        let scrollViewHeight = staticLabelHeight*8 + posterImageView.frame.height +  welcomeTextView.frame.height + holddateTextField.frame.height + holdlocationTextField.frame.height + holderTextField.frame.height + detailTextView.frame.height + moreTextField.frame.height + postButtonWidth + padding*3 + padding*16 + padding*3
        scrollView.contentSize = CGSize(width: ScreenWidth, height: scrollViewHeight + 300)
    }

    @objc func posterTapped(){
        print("postertapped")
        let posterClickSheet = UIAlertController.init(title: "选择上传海报的方式", message: nil, preferredStyle: .actionSheet)
        self.present(posterClickSheet, animated: true)

        posterClickSheet.addAction(.init(title: "从相册上传", style: .default, handler: { (UIAlertAction) in
            if(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
                return
            }
            let photoPicker = UIImagePickerController()
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = false
            photoPicker.delegate = self
            self.present(photoPicker, animated: true, completion: {

            })
        }))
        posterClickSheet.addAction(.init(title: "取消", style: .cancel, handler: { (UIAlertAction) in
        }))

    }

    //MARK: ImagePickerController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        
        
        if(mediaType == "public.image"){
            var posterImage = info[.originalImage] as! UIImage
            posterImageView.image = posterImage
            //进行图片压缩
            
            posterImage = compressImageQuality(posterImage, toByte: 300 * 1024)
            
            let data = posterImage.jpegData(compressionQuality: 1)
            
            
            let posterPath:String = NSHomeDirectory() + "/Library/Caches/"
            let filetmpPath = posterPath + "pushposter" + ".jpg"
            posterPushModel.posterImagePath = filetmpPath
            let fileManager = FileManager.default
            
            if(!fileManager.fileExists(atPath: filetmpPath)){
                fileManager.createFile(atPath: filetmpPath, contents: data, attributes: nil)
            }else{
                try! fileManager.removeItem(atPath: filetmpPath)
                fileManager.createFile(atPath: filetmpPath, contents: data, attributes: nil)
            }
            self.dismiss(animated: true, completion: nil)
            
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }


    //发送海报
    @objc func pushPoster(){
        
        if(checkPoster()){
            self.showLoading(text: "正在发布海报", isSupportClick: false)
            pushManager.api = self.push_api
            
            pushManager.pushPoster(posterPushModel: posterPushModel)
        }
        
        
    }
    
    
    private func checkPoster() -> Bool{
        // test welcome
        if(welcomeTextView.text.count == 0 || welcomeTextView.text.count > 200){
            self.showTempAlert(info: "引语尚未填写或超出200字")
            return false
        }else{
            posterPushModel.welcome = welcomeTextView.text
        }
        
        // test hold date
        if(holddateTextField.text!.count == 0 || holddateTextField.text!.count > 50){
            self.showTempAlert(info: "时间尚未填写或超出50字")
            return false
        }else{
            posterPushModel.holddate = holddateTextField.text
        }
        
        // test hold location
        if(holdlocationTextField.text!.count == 0 || holdlocationTextField.text!.count > 50){
            self.showTempAlert(info: "地点尚未填写或超出50字")
            return false
        }else{
            posterPushModel.holdlocation = holdlocationTextField.text
        }
        
        // test holder
        if(holderTextField.text!.count == 0 || holderTextField.text!.count > 50){
            self.showTempAlert(info: "举办人尚未填写或超出50字")
            return false
        }else{
            posterPushModel.holder = holderTextField.text
        }
        
        // test detail
        if(detailTextView.text!.count == 0 || detailTextView.text!.count > 400){
            self.showTempAlert(info: "简介尚未填写或超出50字")
            return false
        }else{
            posterPushModel.detail = detailTextView.text
        }
        
        // test link
        if(verifyUrl(urlString: moreTextField.text!)){
            posterPushModel.link = moreTextField.text!
        }else{
            self.showTempAlert(info: "链接无法打开")
            return false
        }
        
        return true
        
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    

    

    @objc func dismissButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }



    //MARK:-压缩图片
    func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression),
            data.count > maxLength else { return image }

        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return UIImage(data: data)!
    }
}

// MARK:- NotificationPushManager Delegate
extension PosterPushViewController{
    func pushPosterSuccess() {
        self.hideHUD()
        self.dismiss(animated: true, completion: {
            self.delegate?.posterPushSuccess()
        })
    }
    
    func pushPosterFail(info: String) {
        self.hideHUD()
        self.showTempAlert(info: info)
    }
}

// MARK:- UITextField Delegate
extension PosterPushViewController {
    
    @objc func keyboardHide(tap: UITapGestureRecognizer){
        welcomeTextView.endEditing(true)
        holddateTextField.endEditing(true)
        holdlocationTextField.endEditing(true)
        holderTextField.endEditing(true)
        detailTextView.endEditing(true)
        moreTextField.endEditing(true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        welcomeTextView.endEditing(true)
        holddateTextField.endEditing(true)
        holdlocationTextField.endEditing(true)
        holderTextField.endEditing(true)
        detailTextView.endEditing(true)
        moreTextField.endEditing(true)
    }




   


 
    
}

