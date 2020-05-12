//
//  EditProfileViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EditAccountViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView:UITableView!
    
    let smallPadding:CGFloat = 5
    let padding:CGFloat = 10
    
    var newPwdTextField:UITextField = UITextField()
    
    var newRepeatPwdTextField:UITextField = UITextField()
    
//    var profileModel:ProfileModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "更改账户"
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    

    
    //MARK:- tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "reuse")
        cell.backgroundColor = .secondarySystemBackground
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "账号：" + UserDefaultsManager.getAccount()
        case 1:
            cell.textLabel?.text = "修改密码"
        default:
            break
        }
        
        
        let footer = UIView(frame: CGRect(x: padding, y: cell.frame.maxY - 1, width: UIDevice.SCREEN_WIDTH - 2*padding, height: 1))
        footer.backgroundColor = .darkGray
        cell.addSubview(footer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("account tapped")
        case 1:
            showChangePasswordAlert()
        
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    
}

extension EditAccountViewController{
    // 更改密码
    private func showChangePasswordAlert(){
        
        
        
        let msgAlert = UIAlertController(title: "更改密码", message: "请输入新密码", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            print("确认更改👻")
            
            let result = self.newPwdCheck(password: self.newPwdTextField.text ?? "", repeatPassword: self.newRepeatPwdTextField.text ?? "")
            if(result.0){
                print("change")
                self.sendChangePasswordRequest(newPassword: self.newPwdTextField.text!)
                
            }else{
                self.showTempAlertWithOneSecond(info: "更改失败：" + result.1)
            }
            
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        msgAlert.addAction(ok)
        msgAlert.addAction(cancel)
        msgAlert.addTextField { (textField) in
            self.newPwdTextField = textField
            self.newPwdTextField.isSecureTextEntry = true
            self.newPwdTextField.placeholder = "输入新密码(8-16位，英文字母或数字)"
            self.newPwdTextField.delegate = self
        }
        msgAlert.addTextField { (textField) in
            self.newRepeatPwdTextField = textField
            self.newRepeatPwdTextField.isSecureTextEntry = true
            self.newRepeatPwdTextField.placeholder = "重复输入新密码(8-16位，英文字母或数字)"
            self.newRepeatPwdTextField.delegate = self
        }
        
        self.present(msgAlert, animated: true, completion: nil)
        

    }
    
    // 对输入的内容进行判断所有的格式是否正确
    private func newPwdCheck(password:String, repeatPassword:String) -> (Bool, String){
        
        if(password.count < 8){
            return(false, "密码不足8位")
        }else{
            
            if(!password.equals(str: repeatPassword)){
                return(false, "两次输入密码不同")
            }else{
                return (true, "可以修改")
            }
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case newPwdTextField:
            if(((newPwdTextField.text?.count ?? 0) + string.count > 16) || !Util.onlyInputLettersOrNumbers(string)){
                return false
            }
        case newRepeatPwdTextField:
            if(((newRepeatPwdTextField.text?.count ?? 0) + string.count > 16) || !Util.onlyInputLettersOrNumbers(string)){
                return false
            }
        default:
            return true
        }
        return true
    }
    
    private func sendChangePasswordRequest(newPassword:String){
        let parameters:Parameters = ["user_id":UserDefaultsManager.getUserId(),"password":UserDefaultsManager.getPassword(), "new_password":newPassword]
        
        Alamofire.request(NetworkManager.PROFILE_CHANGE_PWD_API, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
           switch response.result{
           case .success:
               if let data = response.result.value{
                   let json = JSON(data)
                   let result = json["result"].string!
                   if(result.equals(str: "1")){
                       // 修改成功
                        self.showTempAlertWithOneSecond(info: "更改密码成功，请重新登录")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:{
                             ///延迟执行的代码
                            UserDefaultsManager.deleteUserInfo()
                                
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: LoginViewController())
                        })
                    
                   }else{
                       // 修改失败
                    self.showTempAlert(info: "修改失败：" + json["info"].string!)
                   }
                   
               }else{
                   self.showTempAlert(info: "json 解析失败")
               }
           case .failure(let error):
               print(error)
               self.showTempAlert(info: "网络请求失败")
           }
        }
    }
}

