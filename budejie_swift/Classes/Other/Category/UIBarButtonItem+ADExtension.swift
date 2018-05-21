//
//  UIBarButtonItem+ADExtension.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(image: String, highlightedImage: String, target: Any?, action: Selector?) {
        let button = UIButton(type: UIButtonType.custom)
        button.setBackgroundImage(UIImage(named: image), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named: highlightedImage), for: UIControlState.highlighted)
        button.sizeToFit()
        
        if target != nil && action != nil {
            button.addTarget(target!, action: action!, for: UIControlEvents.touchUpInside)
        }
        self.init(customView: button)
    }
    
    class func item(with image: String, highlightedImage: String, target: Any?, action: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: UIButtonType.custom)
        button.setBackgroundImage(UIImage(named: image), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named: highlightedImage), for: UIControlState.highlighted)
        button.sizeToFit()
//        button.addTarget(self, action: #selector(settingClick), for: UIControlEvents.touchUpInside)
        
        if target != nil && action != nil {
            button.addTarget(target!, action: action!, for: UIControlEvents.touchUpInside)
        }
        
        return UIBarButtonItem(customView: button)
    }
}
