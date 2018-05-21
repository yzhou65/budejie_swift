//
//  ADRecommendUserCell.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SDWebImage

class ADRecommendUserCell: UITableViewCell {
    @IBOutlet weak var fansCountLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    
    var user: ADRecommendUser? {
        didSet {
            self.screenNameLabel.text = user!.screen_name!
            
            var fansCount: String?
            if (user!.fans_count!.intValue < 10000) {
                fansCount = "\(user!.fans_count!)人关注"
            }
            else {
                fansCount = String(format: "%.1f万人关注", user!.fans_count!.floatValue / 10000.0)
//                fansCount = "\(user!.fans_count!.intValue / 10000)万人关注"
            }
            self.fansCountLabel.text = fansCount;
            self.headImageView.setProfileImage(with: user!.header!)
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
