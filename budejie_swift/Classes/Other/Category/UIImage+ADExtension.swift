//
//  UIImage+ADExtension.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/1/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

extension UIImage {
    
    // 把正方形profile image剪切成圆形
    func imageClippedToCircle() -> UIImage {
        let size = self.size
        
        // 开启图像上下文
        UIGraphicsBeginImageContext(size)
        
        // 设置裁剪区域
        let path = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        path.addClip()
        
        // 将图片画上去
        self.draw(at: CGPoint.zero)
        
        // 获得新图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /** 除了UIBezierPath以外,也可以直接使用UIGraphicsGetCurrentContext()获得上下文来裁剪 */
    func circleImage() -> UIImage {
        // 开启图像上下文
        UIGraphicsBeginImageContext(self.size)

        // 拿到上下文
        let ctx = UIGraphicsGetCurrentContext()
        
        // 画一个圆
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx?.addEllipse(in: rect)
        
        // 裁剪
        ctx?.clip()
        
        // 将图片画上去
        self.draw(in: rect)
        
        // 获得新图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    var width: CGFloat {
        return self.size.width
    }
    
    var height: CGFloat {
        return self.size.height
    }
    
}
