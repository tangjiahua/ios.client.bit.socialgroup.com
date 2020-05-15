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
    func pushReplyToComment(content:String, item:SquareCommentItem)
    func pushReplyToReply(content:String, item:SquareReplyItem)
}

class WriteViewController: BaseViewController, UITextViewDelegate {
    
    var delegate:WriteViewControllerDelegate?
    
    var textView:UITextView!
    var rightButton:UIBarButtonItem!
    
    var limit:Int!
    var writeType:String!
    
    
    //when reply
    var squareCommentItem:SquareCommentItem!
    var squareReplyItem:SquareReplyItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .secondarySystemBackground
        
        
        let leftButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    deinit{
        print("deinit")
    }
    
    func initCommentTextView(limit:Int){
        self.writeType = "comment"
        self.limit = limit
        
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 300), textContainer: .none)
        textView.backgroundColor = .tertiarySystemBackground
        textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 18)
        view.addSubview(textView)
        
        rightButton = UIBarButtonItem(title: "评论", style: .done, target: self, action: #selector(pushTextViewButtonTapped))
        self.title = "撰写评论"

        rightButton.isEnabled = false
        rightButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = rightButton
        
        textView.delegate = self
    }
    
    func initReplyToCommentTextView(limit:Int, squareCommentItem:SquareCommentItem){
        self.squareCommentItem = squareCommentItem
        self.writeType = "reply_to_comment"
        self.limit = limit
                
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 300), textContainer: .none)
        textView.backgroundColor = .tertiarySystemBackground
        textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 18)
        view.addSubview(textView)
        
        self.title = "回复  " + self.squareCommentItem.user_nickname
        rightButton = UIBarButtonItem(title: "回复", style: .done, target: self, action: #selector(pushTextViewButtonTapped))
        
        rightButton.isEnabled = false
        rightButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = rightButton
        
        textView.delegate = self
    }
    
    func initReplyToReplyTextView(limit:Int, squareReplyItem:SquareReplyItem){
        self.squareReplyItem = squareReplyItem
        
        self.writeType = "reply_to_reply"
        self.limit = limit
                
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: 300), textContainer: .none)
        textView.backgroundColor = .tertiarySystemBackground
        textView.becomeFirstResponder()
        textView.font = .systemFont(ofSize: 18)
        view.addSubview(textView)
        
        self.title = "回复  " + squareReplyItem.nickname
        rightButton = UIBarButtonItem(title: "回复", style: .done, target: self, action: #selector(pushTextViewButtonTapped))
        
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
        }else if(writeType.equals(str: "reply_to_comment")){
            self.delegate?.pushReplyToComment(content: textView.text!, item: squareCommentItem)
        }else if(writeType.equals(str: "reply_to_reply")){
            self.delegate?.pushReplyToReply(content: textView.text!, item: squareReplyItem)
        }
        
    }
    
    
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
    
}

