//
//  RecommendCategory.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import HandyJSON

struct RecommendCategory: HandyJSON {
    // id
    var id: Int = 0
    
    var count: Int = 0
    
    var name: String = ""
    
    
    /** 当前页 */
    var currentPage: Int = 0
    
    /** 总数 */
    var total: Int = 0
    
    //MARK: 懒加载
    /** 这个类别对应的用户数据  */
    var users = [RecommendUser]()
}
