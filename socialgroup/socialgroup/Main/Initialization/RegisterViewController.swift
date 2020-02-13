//
//  RegisterViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/11.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, UITextFieldDelegate, RegisterModelDelegate {

    //获取屏幕尺寸
    let SCREEN_WIDTH = UIDevice.SCREEN_WIDTH
    let SCREEN_HEIGHT = UIDevice.SCREEN_HEIGHT
    let PROMPT_FONT_SIZE:CGFloat = 14
    let MAIN_SIZE = UIScreen.main.bounds.size
    let TXT_FRAME_WIDTH:CGFloat = UIScreen.main.bounds.size.width - 90

    //MARK:- UI
    //返回按钮
    var backButton:UIButton!
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    //确认密码提示框
    var txtPwdConfirm:UITextField!
    //用户名密码输入提示控件
    var txtUserPromptLabel:UILabel!
    var txtPwdPromptLabel:UILabel!
    var promptResultLabel:UILabel!
    //登录 注册按钮
    var registerButton:UIButton!
    
    //MARK:-
    var isAccountAndPasswordFulfill:Bool = false
    var registerModel:RegisterAndLoginModel?
    var account:String{
        return txtUser.text!
    }
    var password:String{
        return txtPwd.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.isHidden = true
        

        // 返回按钮
        backButton = UIButton(frame: CGRect(x: 15, y: UIDevice.STATUS_BAR_HEIGHT + 15, width: 30, height: 30))
        backButton.setImage(UIImage(named: "icon-back"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)


        //登录框背景
        let vLogin =  UIView(frame:CGRect(x: 15, y: backButton.frame.maxY + 15, width: MAIN_SIZE.width - 30, height: 320))
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.layer.cornerRadius = 5
        vLogin.backgroundColor = .tertiarySystemBackground
        self.view.addSubview(vLogin)



        //用户名输入框
        txtUser = UITextField(frame:CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser.placeholder = "账号(只能填写11位数字)"
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
        
         //用户名输入提示控件
        let txtUserPromptStr:String = "注册账号只能输入11位数字，建议您使用手机号注册。该账号不会泄露给除了您以外的任何人，并且只会在您登录的时候使用。请不要使用其他人的手机号进行注册，如果您的手机号已被其他人注册，您可以联系开发者收回该账号的使用权"
        txtUserPromptLabel = UILabel(frame: CGRect(x: txtUser.frame.minX, y: txtUser.frame.maxY + 5, width: txtUser.frame.width, height: UIDevice.getLabHeigh(labelStr: txtUserPromptStr, font: .systemFont(ofSize: PROMPT_FONT_SIZE), width: txtUser.frame.width)))
        txtUserPromptLabel.text = txtUserPromptStr
        txtUserPromptLabel.font = .systemFont(ofSize: PROMPT_FONT_SIZE)
        txtUserPromptLabel.textColor = .lightGray
        txtUserPromptLabel.numberOfLines = 0
        vLogin.addSubview(txtUserPromptLabel)
        
        
         
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x: 30, y: txtUserPromptLabel.frame.maxY + 10, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd.placeholder = "密码(8-16位，英文字母或数字)"
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
    
    
        //确认密码输入框
        txtPwdConfirm = UITextField(frame:CGRect(x: 30, y: txtPwd.frame.maxY + 10, width: vLogin.frame.size.width - 60, height: 44))
        txtPwdConfirm.placeholder = "确认密码(8-16位，英文字母或数字)"
        txtPwdConfirm.delegate = self
        txtPwdConfirm.returnKeyType = .done
        txtPwdConfirm.layer.cornerRadius = 5
        txtPwdConfirm.layer.borderColor = UIColor.lightGray.cgColor
        txtPwdConfirm.layer.borderWidth = 0.5
        txtPwdConfirm.isSecureTextEntry = true
        txtPwdConfirm.textColor = .label
        txtPwdConfirm.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwdConfirm.leftViewMode = UITextField.ViewMode.always
        txtPwdConfirm.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)

        
        //确认密码输入框左侧图标
        let imgPwdConfirm =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwdConfirm.image = UIImage(named:"iconfont-password")
        txtPwdConfirm.leftView!.addSubview(imgPwdConfirm)
        vLogin.addSubview(txtPwdConfirm)
        
        //输入结果提示
        let promptUserResultStr:String = "提示：请输入注册的账号和密码"
        let promptLabelHeight = UIDevice.getLabHeigh(labelStr: promptUserResultStr, font: .systemFont(ofSize: PROMPT_FONT_SIZE), width: TXT_FRAME_WIDTH)
        //账号结果
        promptResultLabel = UILabel(frame: CGRect(x: txtPwdConfirm.frame.minX, y: txtPwdConfirm.frame.maxY + 5, width: TXT_FRAME_WIDTH, height: promptLabelHeight))
        promptResultLabel.text = promptUserResultStr
        promptResultLabel.textColor = .systemRed
        promptResultLabel.numberOfLines = 0
        promptResultLabel.font = .systemFont(ofSize: PROMPT_FONT_SIZE)
        vLogin.addSubview(promptResultLabel)
        
         
        //注册按钮
        registerButton = UIButton(frame: CGRect(x: vLogin.frame.minX, y: vLogin.frame.maxY + 10, width: SCREEN_WIDTH - 30, height: 50))
        registerButton.setTitle("注册", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
        registerButton.backgroundColor = .lightGray
        registerButton.isUserInteractionEnabled = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        view.addSubview(registerButton)
        
    }
    

    // MARK:- textFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtUser.resignFirstResponder()
        txtPwd.resignFirstResponder()
        txtPwdConfirm.resignFirstResponder()
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
        case txtPwdConfirm:
            if(((txtPwdConfirm.text?.count ?? 0) + string.count  > 16) || !Util.onlyInputLettersOrNumbers(string)){
                return false
            }
        default:
            return true
        }
        return true
    }
   
    // MARK:- 自定义的事件处理
    
    //点击注册按钮的处理
    @objc func registerButtonTapped(){
        if(super.isNetworking() && isAccountAndPasswordFulfill){
            //有网络 并且输入正确
            registerModel = RegisterAndLoginModel(account, password)
            registerModel?.registerDelegate = self
            registerModel?.sendRegisterRequest()
            self.showLoading(text: "正在注册", isSupportClick: false)
        }
    }
    
    // 对输入的内容进行判断所有的格式是否正确
    @objc func textFieldChanged(textField: UITextField){
        if(txtUser.text?.count ?? 0 < 11){
            promptResultLabel.text = "提示：账号长度不足11位"
            promptResultLabel.textColor = .systemRed
        }else{
            //账号满足要求，看密码是否满足要求
            if(txtPwd.text?.count ?? 0 < 8){
                promptResultLabel.text = "提示：密码长度不足8位"
                promptResultLabel.textColor = .systemRed
            }else{
                let txtPwdStr = txtPwd.text ?? ""
                let txtPwdConfirmStr = txtPwdConfirm.text ?? ""
                if(txtPwdStr.compare(txtPwdConfirmStr).rawValue != 0){
                    promptResultLabel.text = "提示：两次输入的密码不相同"
                    promptResultLabel.textColor = .systemRed
                }else{
                    promptResultLabel.text = "提示：账号和密码格式正确"
                    promptResultLabel.textColor = .systemGreen
                    registerButton.isUserInteractionEnabled = true
                    registerButton.backgroundColor = .systemBlue
                    isAccountAndPasswordFulfill = true
                    return
                }
            }
        }
        registerButton.isUserInteractionEnabled = false
        registerButton.backgroundColor = .lightGray
        isAccountAndPasswordFulfill = false
    }
    
    
    //MARK:- RegisterAndLoginModelDelegate
    func receiveRegisterResponse(result: String, info: String) {
        self.hideHUD()
        if(result.equals(str: "1")){
            //注册成功
            let alert = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            //注册失败
            let alert = UIAlertController(title: "提示", message: info, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {action in
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    // MARK:- 内存不足
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
