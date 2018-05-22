//
//  RecommendUser.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import HandyJSON

struct RecommendUser: HandyJSON {
    // 头像
    var header: String = ""
    
    // 粉丝
    var fans_count: Int = 0
    
    // 昵称
    var screen_name: String = ""
}
