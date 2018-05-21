//
//  UIView+Category.swift
//  彩票
//
//  Created by Yue Zhou on 2/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit


extension UIView {
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(ori) {
            self.frame.origin = ori
        }
    }
    
    var size: CGSize {
        get {
            return self.bounds.size
        }
        set (size) {
            self.bounds.size = size
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set(width) {
            self.frame.size.width = width
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set(height) {
            self.frame.size.height = height
        }
    }
    
    var x: CGFloat {
        get{
            return self.frame.origin.x
        }
        set(x) {
            self.frame.origin.x = x
        }
    }
    
    var y: CGFloat {
        get{
            return self.frame.origin.y
        }
        set(y) {
            self.frame.origin.y = y
        }
    }
    
    var centerX: CGFloat {
        get{
            return self.center.x
        }
        set(x) {
            self.center.x = x
        }
    }
    
    var centerY: CGFloat {
        get{
            return self.center.y
        }
        set(y) {
            self.center.y = y
        }
    }
    
    func isStayingOnKeyWindow() -> Bool {
        let keyWindow = UIApplication.shared.keyWindow!
    
        //转换坐标系也可以这样写：将子控件坐标系从其父控件坐标系转为窗口坐标系.得到subview在窗口中的frame
        //以主窗口左上角为坐标原点，计算self的矩形框
        let newFrame = keyWindow.convert(self.frame, from: self.superview)
//        let newFrame = self.frame     // 这样写错误, 必须要转化坐标系, 否则"全部内容"的frame永远在(0,0,375,675)而其他的控制器view永远都固定为既有设定(此时只有"全部内容"会往上滚, 其他的不会动), 它们只是contentOffset变了,相对于它们父控件的frame没变.因此一定要用keyWindow.convert来使它们的坐标系变为keyWindow的坐标系
        
        //主窗口的bounds和self的矩形框式是否有重叠
        let isIntersected = newFrame.intersects(keyWindow.bounds)
        return !self.isHidden && self.alpha > 0.01 && self.window == keyWindow && isIntersected
    }
}
