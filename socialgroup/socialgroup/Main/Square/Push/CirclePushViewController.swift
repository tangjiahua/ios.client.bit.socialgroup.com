//
//  CirclePushViewController.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/25.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class CirclePushViewController: BasePushViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布动态"
        // Do any additional setup after loading the view.
    }
    

    override func pushTapped() {
        print("pushCircle")
    }

}
