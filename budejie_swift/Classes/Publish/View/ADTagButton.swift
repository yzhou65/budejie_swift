
//
//  ADTagButton.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/11/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTagButton: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "chose_tag_close_icon"), for: UIControlState.normal)
        self.backgroundColor = adColor(74, 139, 209)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        
        self.sizeToFit()
        self.width += 3 * ADTagMargin
        self.height = ADTagH
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel!.x = ADTagMargin
        self.imageView?.x = self.titleLabel!.frame.maxX + ADTagMargin
    }
}
