//
//  SquarePushViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol BasePushViewControllerDelegate:NSObjectProtocol {
    func pushSuccess()
}

class BasePushViewController: BaseViewController {
    
    var pushMethod:Int! // 1代表broadcast, 2代表circle
    
    var delegate:BasePushViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        
        // Do any additional setup after loading the view.
        // navigationBar
        let cancelButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain, target: self, action: #selector(cancelTapped))
        let pushButton = UIBarButtonItem(image: UIImage(named: "push-black"), style: .plain, target: self, action: #selector(pushTapped))
        self.navigationItem.rightBarButtonItem = pushButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
    }
    

    
    @objc func cancelTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pushTapped(){
        print("push")
    }
    
    func pushWithPhoto(method:String, title:String?, content:String, photos:[UIImage]){
        
        self.showLoading(text: "正在发布", isSupportClick: false)

        var dic = [String:String]()
        dic["socialgroup_id"] = UserDefaultsManager.getSocialGroupId()
        dic["square_item_type"] = method
        if(method.equals(str: "broadcast")){
            dic["title"] = title!
            
        }
        
        dic["content"] = content
        dic["image_count"] = String(photos.count)
        dic["user_id"] = UserDefaultsManager.getUserId()
        dic["password"] = UserDefaultsManager.getPassword()
        
         let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let strJson = String(data: data!, encoding: .utf8)!
  
        do{
            let jsonData = strJson.data(using: .utf8)!
            
            Alamofire.upload(multipartFormData: { (multipart) in
                multipart.append(jsonData, withName: "json")
                for photo in photos{
                    let data = photo.jpegData(compressionQuality: 0.5)!
                    multipart.append(data, withName: "picture",fileName: "pciturefile",  mimeType: "image/*")
                }
                
            }, to: NetworkManager.SQUARE_PUSH_API,method: .post) { (encodingResult) in
                
                switch encodingResult{
                case .success(let upload, _, _):
                    upload.responseJSON { (response) in
                        if let responseData = response.result.value{
                            let json = JSON(responseData)
                            let resultString = json["result"].string
                            if(resultString!.equals(str: "1")){
                                self.pushSuccess()
                            }else{
                                self.pushFail(info: json["info"].string!)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.pushFail(info: "response case .failure")
                }
                
                
            }
        }
        
        
    }
    
    func pushWithoutPhoto(method:String, title:String?, content:String){
        
        self.show(text: "正在发布")
        
        var parameters:Parameters
        
        if(method.equals(str: "broadcast")){
            parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":method, "title":title!, "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        }else{
            parameters = ["socialgroup_id":UserDefaultsManager.getSocialGroupId(), "square_item_type":method, "content":content, "user_id":UserDefaultsManager.getUserId(), "password":UserDefaultsManager.getPassword()]
        }
        
        Alamofire.request(NetworkManager.SQUARE_PUSH_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success:
                if let data = response.result.value{
                    let json = JSON(data)
                    let info = json["result"].string!
                    if(info.equals(str: "1")){
                        self.pushSuccess()
                        
                    }else{
                        self.pushFail(info: json["info"].string!)
                    }
                }
            case .failure(let error):
                print(error)
                self.pushFail(info: "response case .failure")
            }
        }
    }
    
    
    
    
    
    func pushSuccess(){
        
        self.hideHUD()
        
        let alertController = UIAlertController(title: "发布成功", message: nil, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true) {
                self.delegate?.pushSuccess()
            }
            
        }
    }
    
    
    func pushFail(info:String){
        self.hideHUD()
        
        self.showTempAlertWithOneSecond(info: info)
    }

}
