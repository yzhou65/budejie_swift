//
//  ADTabBar.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/25/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        print(#function)
        
        // 设置tabbar的背景图片
        self.backgroundImage = UIImage(named: "tabbar-light")
        
        // init里设置尺寸不合理
//        publishButton.bounds = CGRect(x: 0, y: 0, width: publishButton.currentBackgroundImage!.size.width, height: publishButton.currentBackgroundImage!.size.height)
        
        self.addSubview(self.publishButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static var isTabBarButtonAdded = false

    /**
     * 在此方法中设置子控件尺寸更合理
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.width
        let height = self.height
        
        // 设置发布按钮的frame
//        self.publishButton.size = self.publishButton.currentBackgroundImage!.size // 这句可以放入懒加载, 因为size是一开始就确定的, 只有位置需要在父控件加载完毕后才能确定
        self.publishButton.center = CGPoint(x: width * 0.5, y: height * 0.5)
        
        // 设置其他tabBar上的按钮的位置
        let buttonW: CGFloat = width / 5
        let buttonH = height
        let buttonY: CGFloat = 0
        var buttonX: CGFloat = 0
        var index: Int = 0
        for button in self.subviews {
//            print(button)
            if !button.isKind(of: UIControl.self) || button == self.publishButton {
                continue
            }
            
            buttonX = buttonW * CGFloat(index > 1 ? index + 1 : index)
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            index += 1
            
            //监听按钮点击. layoutSubviews可能会被调用多次，所以为了保证按钮的监听只添加一次，所以要进行判断
            if !ADTabBar.isTabBarButtonAdded {
                (button as! UIControl).addTarget(self, action: #selector(tabBarButtonTapped), for: UIControlEvents.touchUpInside)
            }
        }
        ADTabBar.isTabBarButtonAdded = true
    }
    
    // MARK: - tabBarButton的点击监听
    @objc private func tabBarButtonTapped() {
        NotificationCenter.default.post(name: ADNotification.tabBarDidSelect.notificationName, object: nil)
    }

    
    // MARK: - 懒加载
    private lazy var publishButton: UIButton = {
        let publishButton = UIButton(type: UIButtonType.custom)
        publishButton.setBackgroundImage(UIImage(named: "tabBar_publish_icon"), for: UIControlState.normal)
        publishButton.setBackgroundImage(UIImage(named: "tabBar_publish_click_icon"), for: UIControlState.highlighted)
        publishButton.size = publishButton.currentBackgroundImage!.size
        publishButton.addTarget(self, action: #selector(publish), for: UIControlEvents.touchUpInside)
        return publishButton
    }()
    
    
    // MARK: - 按键回调
    @objc private func publish() {
        //这里不能使用self来present其他控制器，因为self不是控制器
//        UIApplication.shared.keyWindow!.rootViewController!.present(ADPublishViewController(), animated: true, completion: nil)
        
        //窗口级别：
        //UIWindowLevelNormal < UIWindowLevelStatusBar < UIWindowLevelAlert
//        let window = UIWindow(frame: ADScreenBounds)
//        window.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//        window.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
//        window.isHidden = false //window不需要被加到任何控件上，可以直接显示
        
        // 实现半透明界面的发布界面
        ADPublishView.show()
    }
}
