//
//  ADPushGuideView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/4/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

// info.plist里版本号的key rawValue
private let versionKey = "CFBundleShortVersionString"

class ADPushGuideView: UIView {
    
    
    class func guideView(frame: CGRect) -> ADPushGuideView {
        let gv = Bundle.main.loadNibNamed(String(describing: ADPushGuideView.self), owner: nil, options: nil)?.last as! ADPushGuideView
        gv.frame = frame
        return gv
    }
    
    class func show() {
        let curVersion = Bundle.main.infoDictionary![versionKey] as! String
        let oldVersion = UserDefaults.standard.value(forKey: versionKey) as? String
        
        if curVersion != oldVersion {
            // 把当前PushGuideView添加到keyWindow上
            let keyWindow = UIApplication.shared.keyWindow!
            let gv = ADPushGuideView.guideView(frame: keyWindow.bounds)
            keyWindow.addSubview(gv)
        
            // 存储版本号
            UserDefaults.standard.setValue(curVersion, forKey: versionKey)
            UserDefaults.standard.synchronize() // iOS8.0以前必须调用
        }
    }
    

    @IBAction func close(_ sender: Any) {
        self.removeFromSuperview()
    }
    

}
