//
//  ImageBroserModel.swift
//  socialgroup
//
//  Created by 汤佳桦 on 2020/2/20.
//  Copyright © 2020 bitsocialgroup.com. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ImageBrowserModel: NSObject {
    var urlStr:String!

    
    
    var smallImageSize:CGSize{
        return self.smallImageView.image!.size
    }
    var smallImageView:UIImageView!
    
    
    
    
    var bigImageSize:CGSize{
        return self.bigImageView.image!.size
    }
    var bigImageView:UIImageView!
    var bigScrollView:UIScrollView!
    
    
    
    
    
    func smallImageViewframeOriginWindow() -> CGRect{
        return self.smallImageView.convert(self.smallImageView.bounds, to: self.smallImageView.window)
    }
    
    func isCacheImageKey(key:String) -> Bool{
        return (SDImageCache.shared.imageFromMemoryCache(forKey: key) != nil)
    }
    
    func getCurrentImage() -> UIImage{
        if(isCacheImageKey(key: urlStr)){
            return SDImageCache.shared.imageFromMemoryCache(forKey: urlStr)!
        }else{
            return self.smallImageView.image!
        }
    }
    
    func imageViewframeShowWindow() -> CGRect{
        let imageW = smallImageSize.width
        let imageH = smallImageSize.height
        var frame:CGRect
        let H = UIDevice.SCREEN_WIDTH * imageH/imageW
        
        if(imageH/imageW > UIDevice.SCREEN_HEIGHT/UIDevice.SCREEN_WIDTH){
            frame = CGRect(x: 0, y: 0, width: UIDevice.SCREEN_WIDTH, height: H)
        }else{
            frame = CGRect(x: 0, y: UIDevice.SCREEN_HEIGHT/2 - H/2, width: UIDevice.SCREEN_WIDTH, height: H)
        }
        return frame
    }
    
    func bigImageViewFrameOnScrollView() -> CGRect{
        let scrollViewFrame = self.bigScrollView.frame
        let H = scrollViewFrame.size.width * self.bigImageSize.height/self.bigImageSize.width
        let center = self.bigScrollView.center
        return CGRect(x: center.x - scrollViewFrame.size.width/2, y: center.y - H/2, width: scrollViewFrame.size.width, height: H)
    }
    
}
