//
//  ADVerticalButton.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/4/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADVerticalButton: UIButton {
    
    // 代码创建也能居中文字
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 居中
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    // xib创建也能居中文字
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 居中
        self.titleLabel?.textAlignment = NSTextAlignment.center
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 调整图片
        self.imageView?.x = 0
        self.imageView?.y = 0
        self.imageView?.width = self.width
        self.imageView?.height = self.width
        
        // 调整文字
        self.titleLabel?.x = 0
        self.titleLabel?.y = self.imageView!.height
        self.titleLabel?.width = self.width
        self.titleLabel?.height = self.height - self.width
    }

}
