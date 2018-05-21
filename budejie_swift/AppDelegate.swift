//
//  AppDelegate.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/17/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // 统一设置一些空间的appearance, 一次性代码
        self.configAppearance()
        
        // 窗口根控制器
        self.window?.rootViewController = ADTabBarController()
        
        // 显示窗口
        self.window?.makeKeyAndVisible()
        
        // 显示推送引导
        ADPushGuideView.show()
        
        
        // 显示cache文件夹
//        do {
//            let url = try FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
//            print(url.absoluteString)
//        } catch {
//            print(error)
//        }
        
        return true
    }

    
    private func configAppearance() {
        // 以下代码都是一次性的, 放入ADNavigationController的viewDidLoad或init中会被调用4次(有4个子控制器), 没必要
        let bar = UINavigationBar.appearance()
        bar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), for: UIBarMetrics.default)
        bar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]
        
        //设置item
        let item = UIBarButtonItem.appearance()
        //UIControlStateNormal
        var itemAttrs = [String: Any]()
        itemAttrs[NSForegroundColorAttributeName] = UIColor.black
        itemAttrs[NSFontAttributeName] = UIFont.systemFont(ofSize: 17.0)
        item.setTitleTextAttributes(itemAttrs, for: UIControlState.normal)
        
        // UIControlStateDisabled
        var itemDisabledAttrs = [String: Any]()
        itemDisabledAttrs[NSForegroundColorAttributeName] = UIColor.lightGray
        item.setTitleTextAttributes(itemDisabledAttrs, for:UIControlState.disabled)
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到顶部
        self.topWindow.isHidden = false
    }
    
    // MARK: - 懒加载
    lazy var topWindow: UIWindow = ADTopWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
    
}

