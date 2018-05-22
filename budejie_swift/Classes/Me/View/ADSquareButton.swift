//
//  ADSquareButton.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADSquareButton: UIButton {
    
    var square = Square() {
        didSet {
            self.setTitle(square.name, for: UIControlState.normal)
            
            // 利用SDWebImage给按钮设置image
            self.sd_setImage(with: URL(string: square.icon), for: UIControlState.normal)
        }
    }
    
    // MARK: - 构造
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 初始设置
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    private func config() {
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.setBackgroundImage(UIImage(named: "mainCellBackground"), for: UIControlState.normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //调整图片
        self.imageView!.y = self.height * 0.15
        self.imageView!.width = self.width * 0.5
        self.imageView!.height = self.imageView!.width
        self.imageView!.centerX = self.width * 0.5
        
        //调整文字
        self.titleLabel!.x = 0
        self.titleLabel!.y = self.imageView!.frame.maxY
        self.titleLabel!.width = self.width
        self.titleLabel!.height = self.height - self.titleLabel!.y
    }
}
