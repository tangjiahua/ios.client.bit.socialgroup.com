//
//  HeaderGestureRecognizer.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/14.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import UIKit

class HeaderGetureRecognizer: UIGestureRecognizer {
    
    public var touchPoint = CGPoint.zero
    public var movePoint = CGPoint.zero
    public var touchEnded:Bool = true
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: view)
        touchPoint = location
        touchEnded = false
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = touches.first! as UITouch
        let currentTouch = touch.location(in: view)
        
        movePoint.x = currentTouch.x - touchPoint.x
        movePoint.y = currentTouch.y - touchPoint.y
        
        touchPoint = currentTouch
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        touchEnded = true
        self.reset()
        self.state = .ended
    }
    
    
}
