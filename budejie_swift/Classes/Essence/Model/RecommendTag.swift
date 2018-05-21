//
//  RecommendTag.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import HandyJSON

struct RecommendTag: HandyJSON {
    /** 图片 */
    var image_list: String = ""
    
    /** 名字 */
    var theme_name: String = ""
    
    /** 订阅数 */
    var sub_number: Int = 0
}
