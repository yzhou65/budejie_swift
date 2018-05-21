//
//  ADTabBarController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/25/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let attrs = [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
        let selectedAttrs = [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)]
        
        // 通过appearance一次性设置所有tabBarItem
        let item = UITabBarItem.appearance()
        item.setTitleTextAttributes(attrs, for: UIControlState.normal)
        item.setTitleTextAttributes(selectedAttrs, for: UIControlState.selected)

//        print("ADTabBarController: " + #function)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)   // 这句话完了就会立即进入viewDidLoad, 应该把appearance设置放在这句之前
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupChildViewController(with: ADEssenceViewController(), title: "精华", image: "tabBar_essence_icon", selectedImage: "tabBar_essence_click_icon")
        self.setupChildViewController(with: ADNewViewController(), title: "新帖", image: "tabBar_new_icon", selectedImage: "tabBar_new_click_icon")
        self.setupChildViewController(with: ADFriendTrendsViewController(), title: "关注", image: "tabBar_friendTrends_icon", selectedImage: "tabBar_friendTrends_click_icon")
        self.setupChildViewController(with: ADMeViewController(), title: "我", image: "tabBar_me_icon", selectedImage: "tabBar_me_click_icon")
        
        // 替换tabBar
        self.setValue(ADTabBar(), forKeyPath: "tabBar")
        
        // 默认一进来app就选择哪个tab
        self.selectedIndex = 0
    }
    

    private func setupChildViewController(with vc: UIViewController, title: String, image: String, selectedImage: String) {
//        vc.navigationItem.title = title
//        vc.tabBarItem.title = title
        
        vc.title = title
        vc.tabBarItem.image = UIImage(named: image)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)
        
//        vc.view.backgroundColor = adGlobalColor() //这句话会导致所有控制器都在一进入app就创建(提前创建了控制器)，而不是点击某个tab使用该控制器时才创建, 不符合懒加载习惯
        
        // 包装一个导航控制器, 添加导航控制器为tabBarController的子控制器
        let nav = ADNavigationController(rootViewController: vc)
        self.addChildViewController(nav)
    }
}
