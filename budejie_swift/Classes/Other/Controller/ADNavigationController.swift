//
//  ADNavigationController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/25/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADNavigationController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置左滑返回
        self.configLeftSwipeReturn()
    }
    
    private func configLeftSwipeReturn() {
        // 先disable系统默认的这个UIScreenEdgePanGestureRecognizer
        let gesture: UIScreenEdgePanGestureRecognizer = self.interactivePopGestureRecognizer as! UIScreenEdgePanGestureRecognizer
        gesture.isEnabled = false
        //        print(gesture.delegate)
        
        // 取出某个对象里面的属性: 1. KVC(前提是知道属性名) 2. 运行时runtime库
        // copyIvarList只能获取哪个类下面的属性,并不会越界(不会把其父类的属性遍历出来)
        // Class:想过去哪个类的成员属性
        // count:告诉你当前类里面成员属性的总数
        
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        for i in 0..<count {
            let name = ivar_getName(ivars[Int(i)])!
//            print(String.init(cString: name))
        }
        
        // 通过运行时得到_targets
        guard let targets = gesture.value(forKeyPath: "_targets") as?   [AnyObject] else {
            return
        }
        //        print(targets)    // 打印出一组[(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fc85c80d240>)]
        
        // 通过kvc可以拿到target
        let target = targets.first!.value(forKeyPath: "target")!
//        print(target)   //  打印出<_UINavigationInteractiveTransition: 0x7fcd12614b40>
        
        // 通过kvc无法拿到action, 必须通过Selector包装字符串
        //        let action = targets.first!.value(forKeyPath: "action")!
        
        // 至此通过runtime拿到了target和action
        let action = Selector(("handleNavigationTransition:"))
        
        //        let pan = UIPanGestureRecognizer(target: target, action: action)
        
        // 再或者因为运行时获得的target == _UINavigationInteractiveTransition == self.interactivePopGestureRecognizer.delegate, 所以可以直接:
        let pan = UIPanGestureRecognizer(target: self.interactivePopGestureRecognizer?.delegate, action: action)
        
        gesture.view?.addGestureRecognizer(pan)
    }
    
    /**
     * 要自定义每个push进来的控制器的返回键, 就要拦截pushViewController方法
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        super.pushViewController(viewController, animated: animated)  // 这句话要在覆盖了返回键以后调用
        
        // 如果push进来的不是第一个控制器
//        adPrint("count = \(self.childViewControllers.count)")
        if self.childViewControllers.count > 0 {
            let button = UIButton(type: UIButtonType.custom)
            button.setTitle("返回", for: UIControlState.normal)
            button.setImage(UIImage(named: "navigationButtonReturn"), for: UIControlState.normal)
            button.setImage(UIImage(named: "navigationButtonReturnClick"), for: UIControlState.highlighted)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setTitleColor(UIColor.red, for: UIControlState.highlighted)
            button.size = CGSize(width: 70, height: 30)
            //        button.sizeToFit()
            
            //让按钮内部的所有内容左对齐
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) //再向左边移动一点，让其紧靠左边
            
            button.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
            
            // 把push进来的控制器的返回键设置为以上自定义的带有"返回"的按钮
            //        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(customView: button) // 无法自定backBarButtonItem
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            
            //隐藏bottomBar. 如果先调用了super.push, 那么这里就无法隐藏bottomBar
//            print(viewController)
            viewController.hidesBottomBarWhenPushed = true
        }
        
        //这句super push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
        super.pushViewController(viewController, animated: animated)
    }
    
    
    @objc private func back() {
        self.popViewController(animated: true)
        
//        adPrint(self.childViewControllers.count)
    }
}
