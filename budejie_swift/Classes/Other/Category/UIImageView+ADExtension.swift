//
//  UIImageView+ADExtension.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/1/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func setProfileImage(with imageURL: String) {
        let pl = UIImage(named: "defaultUserIcon")!
        
        // 要使用带有options的sd_setImage方法. 
        // 使用不带有options的sd_setImage方法会报ambiguous use错误
        self.sd_setImage(with: URL(string: imageURL), placeholderImage: pl, options: SDWebImageOptions.init(rawValue: 0)) { (image: UIImage?, error, _, _) in
//            self.image = (image != nil ? image!.circleImage(): pl)
            self.image = (image != nil ? image!.imageClippedToCircle(): pl)
        }
    }
}
