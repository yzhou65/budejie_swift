//
//  ADTopWindow.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTopWindow: UIWindow {
    
    // MARK: - 构造
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.windowLevel = UIWindowLevelAlert
        self.rootViewController = UIViewController()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(windowTapped)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 点击手势
    /**
     * addGestureRecognizer中target的self是个类，所以这个windowClick必须是类方法监听窗口的点击
     */
     @objc private func windowTapped() {
        let w = UIApplication.shared.keyWindow!
        self.searchScrollView(in: w)
    }
    
     @objc private func searchScrollView(in superview: UIView) {
        for subview in superview.subviews {
            //如果是scrollView，滚动到最顶部.
            // isStayingOnKeyWindow的判断保证了滑到屏幕外的scrollView,tableView等不会被一起滚到顶部
            if subview.isKind(of: UIScrollView.self) && subview.isStayingOnKeyWindow() {
                let sv: UIScrollView = subview as! UIScrollView
//                sv.setContentOffset(CGPoint.zero, animated: true)   //传入的offset不能是CGPointZero，因为scrollView能回到的最上面应该是一个负数偏移量（在scrollView上面还有标题，如果设为CGPointZero就会盖住标题）
                
                //                sv.setContentOffset(CGPoint(x: 0, y: -sv.contentInset.top), animated: true) // 也不能把x:0传入这个setContentOffset方法, 否则声音, 图片, 段子等共享的那个scrollView就会滑动到x=0位置, 即第一个子控件view(全部内容)
                
                var offset = sv.contentOffset
                offset.y = -sv.contentInset.top
                sv.setContentOffset(offset, animated: true)
            }
            
            // 递归继续查找子控件
            searchScrollView(in: subview)
        }
    }
    
}
