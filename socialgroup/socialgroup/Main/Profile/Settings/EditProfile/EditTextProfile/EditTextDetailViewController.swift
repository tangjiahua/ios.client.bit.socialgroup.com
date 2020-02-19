//
//  EditTextDetailViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

protocol EditTextDetailViewControllerDelegate:NSObjectProtocol {
    func changeInTextView(title:String, info:String)
    func changeInTextField(title:String, info:String)
    func changeInPickerView(title:String, info:String)
}

class EditTextDetailViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
   
    var delegate:EditTextDetailViewControllerDelegate?
    
    
    var textField:UITextField!
    var textView:UITextView!
    var genderPickerView:UIPickerView!
    
    var pickRow:Int = 0
    var sexes = ["女", "男"]
    var limit:Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .secondarySystemBackground
        
        
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
        
    }
    
    func initPickerView(title:String){
        navigationItem.title = title
        genderPickerView = UIPickerView(frame: CGRect(x: 0, y: UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT, width: UIDevice.SCREEN_WIDTH, height: 200))
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.backgroundColor = .secondarySystemBackground
        view.addSubview(genderPickerView)
        let rightButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(savePickerViewButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    

    func initTextField(title:String, oldValue:String, limit:Int){
        
        self.limit = limit
        
        
        
        navigationItem.title = title
        textField = UITextField(frame: CGRect(x: 0, y: UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT, width: UIDevice.SCREEN_WIDTH, height: 50))
        textField.text = oldValue
        textField.backgroundColor = .tertiarySystemBackground
        textField.becomeFirstResponder()
        textField.clearButtonMode = .always
        view.addSubview(textField)
        let rightButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveTextFieldButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        textField.delegate = self
        
    }
    
    
    func initTextView(title:String, oldValue:String, limit:Int){
        
        self.limit = limit
        navigationItem.title = title
        textView = UITextView(frame: CGRect(x: 0, y: UIDevice.NAVIGATION_BAR_HEIGHT + UIDevice.STATUS_BAR_HEIGHT, width: UIDevice.SCREEN_WIDTH, height: 300), textContainer: .none)
        textView.text = oldValue
        textView.backgroundColor = .tertiarySystemBackground
        textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 18)
        view.addSubview(textView)
        
        let rightButton = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveTextViewButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
        textView.delegate = self
    }
    
    
    //MARK:- tableview

    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(textView.text.count + text.count > limit){
            return false
        }else{
            return true
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if((textField.text?.count ?? 0) + string.count > limit){
            return false
        }else{
            return true
        }
    }
    
    
    //MARK:-  picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickRow = row
    }
    
    
    
    
    //MARK:- tapped actions
    @objc func saveTextViewButtonTapped(){
        
        self.delegate?.changeInTextView(title: navigationItem.title!, info: textView.text)
        
        self.dismiss(animated: true, completion: nil)
        print("save")
    }
    
    @objc func saveTextFieldButtonTapped(){
        self.delegate?.changeInTextField(title: navigationItem.title!, info: textField.text!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func savePickerViewButtonTapped(){
        
        self.delegate?.changeInPickerView(title: navigationItem.title!, info: sexes[pickRow])
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
}
