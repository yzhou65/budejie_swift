//
//  ADRecommendCategoryCell.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADRecommendCategoryCell: UITableViewCell {
    @IBOutlet weak var redIndicator: UIView!
    
    var category: ADRecommendCategory? {
        didSet {
            self.textLabel?.text = category!.name!
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = adColor(244, 244, 244)
        self.redIndicator.backgroundColor = adColor(219, 21, 26)
        
        //当cell的selection为None时，即使cell被选中，内部子控件也不会进入高亮状态
//        self.textLabel?.textColor = adColor(78, 78, 78);
//        self.textLabel?.highlightedTextColor = adColor(219, 21, 26);
//        self.selectedBackgroundView = UIView()
    }
    
    
    /**
     * 先在xib中把cell的selection改为none, 然后重写此方法来自定义cell选中状态,调节redIndicator的显示或隐藏, 以及文字的颜色
     * 自定义cell被selected和deselected的不同状态
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.redIndicator.isHidden = !selected
        self.textLabel?.textColor = (selected ? self.redIndicator.backgroundColor : adColor(78, 78, 78))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //重新调整内部textLabel的frame，否则字会挡住自制分割线（其实就是一个height＝1的UIView）
        self.textLabel!.y = 2
        self.textLabel?.height = self.contentView.height - 2 * self.textLabel!.y
//        self.textLabel?.height = self.contentView.height - 1
    }
}
