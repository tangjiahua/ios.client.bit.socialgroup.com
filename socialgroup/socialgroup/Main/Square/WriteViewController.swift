//
//  WriteViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/29.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import Alamofire
//
protocol WriteViewControllerDelegate: NSObjectProtocol {
    func pushComment(content:String)
    func pushReply()
}

class WriteViewController: BaseViewController, UITextViewDelegate {
    
    var delegate:WriteViewControllerDelegate?
    
    var textView:UITextView!
    var rightButton:UIBarButtonItem!
    
    var limit:Int!
    
    var writeType:String! // comment or reply
    
    //comment
    var square_item_id:String!
    var square_item_type:String!
    var content:String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .secondarySystemBackground
        
        
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func initTextView(limit:Int, writeType:String, square_item_type:String, square_item_id:String){
        
        self.writeType = writeType
        self.limit = limit
        self.square_item_id = square_item_id
        self.square_item_type = square_item_type
        
        
        navigationItem.title = "撰写"
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 300), textContainer: .none)
        textView.backgroundColor = .tertiarySystemBackground
        textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 18)
        view.addSubview(textView)
        
        if(writeType.equals(str: "comment")){
            rightButton = UIBarButtonItem(title: "评论", style: .done, target: self, action: #selector(pushTextViewButtonTapped))
        }else if(writeType.equals(str: "reply")){
            rightButton = UIBarButtonItem(title: "回复", style: .done, target: self, action: #selector(pushTextViewButtonTapped))
        }
        rightButton.isEnabled = false
        rightButton.tintColor = .systemGray
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
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.count == 0){
            rightButton.isEnabled = false
            rightButton.tintColor = .systemGray
        }else{
            rightButton.isEnabled = true
            rightButton.tintColor = .systemBlue
        }
    }
    
    //MARK:- tapped actions
    @objc func pushTextViewButtonTapped(){
        self.dismiss(animated: true, completion: nil)
        if(writeType.equals(str: "comment")){
            self.delegate?.pushComment(content: textView.text!)
        }else if(writeType.equals(str: "reply")){
            self.delegate?.pushReply()
        }
        
    }
    
    
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
    
}

