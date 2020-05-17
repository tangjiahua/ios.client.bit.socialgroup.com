//
//  TermsAndPrivacyViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/5/17.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit
import WebKit

class WebPageViewController: UINavigationController {
    
    var wkWebView:WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    func initPrivacy(){
        //创建
        wkWebView = WKWebView()

        //设置位置和大小
        wkWebView?.frame = self.view.frame;
        wkWebView?.load(NSURLRequest(url: NSURL(string:"https://bitsocialgroup.com/privacy.html")! as URL) as URLRequest)
        self.view.addSubview(wkWebView!)
    }
    
    func initTerms(){
        //创建
        wkWebView = WKWebView()

        //设置位置和大小
        wkWebView?.frame = self.view.frame;
        wkWebView?.load(NSURLRequest(url: NSURL(string:"https://bitsocialgroup.com/terms.html")! as URL) as URLRequest)
        
        self.view.addSubview(wkWebView!)
    }

}
