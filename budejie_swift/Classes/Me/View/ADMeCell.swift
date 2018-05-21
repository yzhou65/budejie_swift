//
//  ADMeCell.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADMeCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        self.backgroundView = UIImageView(image: UIImage(named: "mainCellBackground"))
        self.textLabel?.textColor = UIColor.darkGray
        self.textLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.imageView?.image == nil {
            return
        }
        
        self.imageView!.width = 30
        self.imageView!.height = self.imageView!.width
        self.imageView!.centerY = self.contentView.height * 0.5
        self.textLabel?.x = self.imageView!.frame.maxX + ADTopicCellMargin
    }

}
