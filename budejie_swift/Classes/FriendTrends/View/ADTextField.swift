//
//  ADTextField.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/4/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

// 可以用运行时获得_placeholderLabel这个key. 通过kvc和.textColor可以获取到占位字符串的label的颜色属性并进行操作
private let ADPlaceholderKeyPath = "_placeholderLabel.textColor"

class ADTextField: UITextField {

    var placeholderColor: UIColor? {
        didSet {
//            let label = self.value(forKey: ADPlaceholderKeyPath) as! UILabel
//            label.textColor = placeholderColor!
            self.setValue(placeholderColor!, forKeyPath: ADPlaceholderKeyPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置光标颜色和文字颜色一致
        self.tintColor = self.textColor
        
        //不成为第一响应者
        _ = self.resignFirstResponder()
    }
    

    override func becomeFirstResponder() -> Bool {
        //修改占位文字颜色
//        let phLabel = self.value(forKey: ADPlaceholderKeyPath) as! UILabel
//        phLabel.textColor = self.textColor
        
        self.setValue(self.textColor, forKeyPath: ADPlaceholderKeyPath)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
//        let phLabel = self.value(forKey: ADPlaceholderKeyPath) as! UILabel
//        phLabel.textColor = UIColor.gray
        self.setValue(UIColor.gray, forKeyPath: ADPlaceholderKeyPath)
        return super.resignFirstResponder()
    }
    
    // MARK: - 运行时相关
    
    /**
     运行时（Runtime）：
     苹果官方一套C语言库
     能做很多底层操作（比如访问隐藏的一些成员变量／成员方法。。。）
     */
    class func printIvars() {
        //拷贝出所有的成员变量列表(一般带有_, 隐藏的且外界拿不到), 要传入一个UInt32型指针来保存成员变量个数
        var count: UInt32 = 0
        
        // 用propertyList获取不到_placeholderLabel
//        let properties = class_copyPropertyList(UITextField.self, &count)!
        let ivars = class_copyIvarList(UITextField.self, &count)!
        
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let cName = ivar_getName(ivar)!
            
            print(String(cString: cName) + "---" + String(cString:ivar_getTypeEncoding(ivar)))  // 成员变量, 类型
        }
        free(ivars)
    }
    
    
    class func printProperties() {
        //拷贝出所有的属性列表(外界能拿到的属性), 要传入一个UInt32型指针来保存成员变量个数
        var count: UInt32 = 0
        
        // 用propertyList获取不到_placeholderLabel
                let properties = class_copyPropertyList(UITextField.self, &count)!
        
        for i in 0..<count {
            let property = properties[Int(i)]
            let cName = property_getName(property)!
            print(String(cString: cName) + "---" + String(cString: property_getAttributes(property)))  // 属性名, 类型
        }
        free(properties)
    }
}
