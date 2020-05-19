//
//  LoginViewController.swift
//  Mask
//
//  Created by 汤佳桦 on 2019/12/22.
//  Copyright © 2019 Beijing Institute of Technology. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:BaseViewController,UITextFieldDelegate, LoginModelDelegate {
    
    
    var ScreenWidth = UIDevice.SCREEN_WIDTH
    var ScreenHeight = UIDevice.SCREEN_HEIGHT
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    
    //登录 注册按钮
    var loginButton:UIButton!
    var registerButton:UIButton!
    var checkButton:UIButton!
    
    var isChecked:Bool = false
    
    var registerVC:RegisterViewController!
    
    //MARK:-
    var loginModel:RegisterAndLoginModel?
    
    var account:String{
        return txtUser.text!
    }
    
    var password:String{
        return txtPwd.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.isHidden = true
        
//        self.view.backgroundColor=[UIColor, colorWithHexString:@"#"];
        view.backgroundColor = UIDevice.kRGBColorFromHex(rgbValue: 0x1CA1F0)

        
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        let loginLogoHeight:CGFloat = 120
        let loginLogo = UIImageView(frame: CGRect(x: 0, y:0, width: mainSize.width, height: loginLogoHeight))
        loginLogo.image = UIImage(named: "LoginLogo")
        loginLogo.contentMode = .scaleAspectFill
        loginLogo.layer.masksToBounds = true
        loginLogo.layer.cornerRadius = 5
        loginLogo.backgroundColor = .tertiarySystemBackground
        self.view.addSubview(loginLogo)
        
        
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: loginLogo.frame.maxY + 20, width: mainSize.width - 30, height: 160))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.layer.cornerRadius = 5
        vLogin.backgroundColor = .tertiarySystemBackground
        self.view.addSubview(vLogin)
        
        
        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.placeholder = "账号"
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.textColor = .label
        txtUser.keyboardType = .numberPad
        txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextField.ViewMode.always
        txtUser.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)
        
        //用户名输入框左侧图标
        let imgUser =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.placeholder = "密码"
        txtPwd.delegate = self
        txtPwd.returnKeyType = .done
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.textColor = .label
        txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextField.ViewMode.always
        txtPwd.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        
        // 勾选框
        checkButton = UIButton(frame: CGRect(x: vLogin.frame.minX, y: vLogin.frame.maxY + 20, width: 30, height: 30))
        checkButton.isSelected = false
        checkButton.setImage(UIImage(named: "check_off"), for: .normal)
        checkButton.setImage(UIImage(named: "check_on"), for: .selected)
        checkButton.addTarget(self, action: #selector(checkClick), for: .touchUpInside)
        view.addSubview(checkButton)
        
        
        //勾选
        let tintLabel = UILabel(frame: CGRect(x: checkButton.frame.maxX + 10, y:  vLogin.frame.maxY + 20, width: ScreenWidth - 20, height: 30))
        tintLabel.text = "勾选左框表示我已经阅读并且同意："
        tintLabel.textColor = .white
        view.addSubview(tintLabel)
        
        
        // 隐私政策条目
        let privacyButton = UILabel(frame: CGRect(x: checkButton.frame.maxX + 10, y:  tintLabel.frame.maxY, width: 70, height: 30))
        privacyButton.text = "隐私政策"
        privacyButton.textColor = .blue
        privacyButton.isUserInteractionEnabled = true
        let gestureReco = UITapGestureRecognizer(target: self, action: #selector(clickPrivacy))
        privacyButton.addGestureRecognizer(gestureReco)
        view.addSubview(privacyButton)
        
        // 以及
        let andLabel = UILabel(frame: CGRect(x: privacyButton.frame.maxX, y:  tintLabel.frame.maxY, width: 35, height: 30))
        andLabel.text = "以及"
        andLabel.textColor = .white
        view.addSubview(andLabel)
        
        
        // 服务条款
        let termsButton = UILabel(frame: CGRect(x: andLabel.frame.maxX, y:  tintLabel.frame.maxY, width: 70, height: 30))
        termsButton.text = "服务条款"
        termsButton.textColor = .blue
        termsButton.isUserInteractionEnabled = true
        let gestureReco2 = UITapGestureRecognizer(target: self, action: #selector(clickTerms))
        termsButton.addGestureRecognizer(gestureReco2)
        view.addSubview(termsButton)
        
        
        //登录按钮
        loginButton = UIButton(frame: CGRect(x: vLogin.frame.minX, y: privacyButton.frame.maxY + 20, width: ScreenWidth - 30, height: 50))
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .lightGray
        loginButton.isUserInteractionEnabled = false
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        //注册按钮
        registerButton = UIButton(frame: CGRect(x: loginButton.frame.minX, y: loginButton.frame.maxY + 20, width: ScreenWidth - 30, height: 50))
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = .systemBlue
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        
    }
    
    
    //MARK:- textfield delegate function
    
    @objc func checkClick(){
        checkButton.isSelected = !checkButton.isSelected
        isChecked = checkButton.isSelected
        if((txtUser.text!.count != 0) && (txtPwd.text!.count != 0) && isChecked){
            loginButton.isUserInteractionEnabled = true
            loginButton.backgroundColor = .systemBlue
            return
        }
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = .lightGray
    }
    
    @objc func clickPrivacy(){
        let privacyVC = WebPageViewController()
        privacyVC.initPrivacy()
        self.navigationController?.pushViewController(privacyVC, animated: true)
//        self.present(privacyVC, animated: true, completion: nil)
    }
    
    @objc func clickTerms(){
        let termsVC = WebPageViewController()
        termsVC.initTerms()
        self.navigationController?.pushViewController(termsVC, animated: true)
//        self.present(termsVC, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtUser.resignFirstResponder()
        txtPwd.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtUser:
            if(((txtUser.text?.count ?? 0) + string.count > 11) || !Util.onlyInputNumbers(string)){
                return false
            }
        case txtPwd:
            if(((txtPwd.text?.count ?? 0) + string.count > 16) || !Util.onlyInputLettersOrNumbers(string)){
                return false
            }
        default:
            return true
        }
        return true
    }
    
    
    //MARK:- 自定义的事件
    // 对输入的内容进行判断所有的格式是否正确
    @objc func textFieldChanged(textField: UITextField){
        if((txtUser.text!.count != 0) && (txtPwd.text!.count != 0) && isChecked){
            loginButton.isUserInteractionEnabled = true
            loginButton.backgroundColor = .systemBlue
            return
        }
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = .lightGray
        
    }
    
    
    
    //MARK:- button click function
    
    @objc func loginButtonTapped(){
        loginModel = RegisterAndLoginModel(account, password)
        loginModel?.loginDelegate = self
        loginModel?.sendLoginRequest()
        self.showLoading(text: "正在登录", isSupportClick: false)
    }
    
    @objc func registerButtonTapped(){
        registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- RegisterAndLoginDelegate
    func receiveLoginSuccessResponse(result: String, info: String) {
        print("user_id  " + info)
        self.hideHUD()
        
        
        let chooseSGVC = ChooseSocialGroupViewController()
        
        chooseSGVC.chooseSocialGroupModel = ChooseSocialGroupModel(account, info, password)
        
        self.navigationController?.pushViewController(chooseSGVC, animated: true)
    }
    
    func receiveLoginFailResponse(result: String, info: String) {
        self.hideHUD()
        let alert = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


