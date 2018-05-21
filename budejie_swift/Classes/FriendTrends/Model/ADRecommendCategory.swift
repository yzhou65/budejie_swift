//
//  ADRecommendCategory.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADRecommendCategory: NSObject {
    
    // id
    var id: NSNumber?
    
    var count: NSNumber?
    
    var name: String?
    
    
    /** 当前页 */
    var currentPage: Int = 0
    
    /** 总数 */
    var total: Int = 0
    
    //MARK: 懒加载
    /** 这个类别对应的用户数据  */
    lazy var users = [ADRecommendUser]()
}
