//
//  User.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import HandyJSON

struct User: HandyJSON {
    /** 用户名 */
    var username: String = ""
    /** 性别 */
    var sex: String = ""
    /** 头像 */
    var profile_image: String = ""
}
