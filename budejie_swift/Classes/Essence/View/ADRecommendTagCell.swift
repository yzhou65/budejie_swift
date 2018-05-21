//
//  ADRecommendTagCell.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/3/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADRecommendTagCell: UITableViewCell {
    @IBOutlet weak var imageListImageView: UIImageView!
    @IBOutlet weak var themeNameLabel: UILabel!
    @IBOutlet weak var subNumberLabel: UILabel!
    
    var recommendTag: ADRecommendTag? {
        didSet {
            self.imageListImageView.setProfileImage(with: recommendTag!.image_list!)
            self.themeNameLabel.text = recommendTag!.theme_name!
            
            var subNumber = ""
            if recommendTag!.sub_number!.intValue < 10000 {
                subNumber = "\(recommendTag!.sub_number!)人订阅"
            } else {
                subNumber = String(format: "%.1f万人订阅", recommendTag!.sub_number!.floatValue / 10000.0)
            }
            self.subNumberLabel.text = subNumber
        }
    }
    
    
    /**
     重新设置cell的尺寸. 外面无论怎么设置cell的frame也会被这个方法覆盖。
     这样就可以达到左边出现空隙，cell和cell之间也有分隔线的效果
     */
    override var frame: CGRect {
        get{ return super.frame }
        set(frame) {
            var f = frame
            f.origin.x = 5
            f.size.width -= 2 * f.origin.x
            f.size.height -= 1
            super.frame = f
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
