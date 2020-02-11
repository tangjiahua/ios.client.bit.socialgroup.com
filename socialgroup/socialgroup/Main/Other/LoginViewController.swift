//
//  LoginViewController.swift
//  Mask
//
//  Created by 汤佳桦 on 2019/12/22.
//  Copyright © 2019 Beijing Institute of Technology. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController:UIViewController,UITextFieldDelegate {
    
    var ScreenWidth = Util.SCREEN_WIDTH
    var ScreenHeight = Util.SCREEN_HEIGHT
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    
    //登录 注册按钮
    var loginButton:UIButton!
    var registerButton:UIButton!

    var registerVC:RegisterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        
        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: 250, width: mainSize.width - 30, height: 160))
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
        
        //密码输入框左侧图标
        let imgPwd =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        vLogin.addSubview(txtPwd)
        
        
        //登录按钮
        loginButton = UIButton(frame: CGRect(x: vLogin.frame.minX, y: vLogin.frame.maxY + 20, width: ScreenWidth - 30, height: 50))
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        //注册按钮
        registerButton = UIButton(frame: CGRect(x: loginButton.frame.minX, y: loginButton.frame.maxY + 20, width: ScreenWidth - 30, height: 50))
        registerButton.setTitle("想要注册", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = .systemBlue
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
        
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtUser.resignFirstResponder()
        txtPwd.resignFirstResponder()
    }
    
    @objc func loginButtonTapped(){
        let mainVC = MainController()
            
        UIApplication.shared.windows.first?.rootViewController = mainVC
    }
    
    @objc func registerButtonTapped(){
        registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


