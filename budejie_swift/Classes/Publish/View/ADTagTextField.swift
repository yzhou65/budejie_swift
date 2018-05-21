//
//  ADTagTextField.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/11/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTagTextField: UITextField {
    
    var deleteBlock: (() -> ())?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.placeholder = "多个标签用逗号或者换行隔开"
        
        //设置了占位文字内容以后，才能设置占位位子的颜色，因为懒加载
        self.setValue(UIColor.gray, forKeyPath: "_placeholderLabel.textColor")
        self.height = ADTagH
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     重写此方法也能监听键盘的输入，比如输入“换行”
     */
//    override func insertText(_ text: String) {
//        super.insertText(text)
//        print(text == "\n")
//    }

    
    override func deleteBackward() {
        if let block = self.deleteBlock {
            block()
        }
        super.deleteBackward()
    }
}
