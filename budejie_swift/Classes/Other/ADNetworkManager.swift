//
//  ADNetworkManager.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import AFNetworking

class ADNetworkManager: AFHTTPSessionManager {

//    static let m: ADNetworkManager = ADNetworkManager()
    
    static let m: ADNetworkManager = {
        // note: baseURL结尾必须是 "/"
        let url = URL(string: "https://api.budejie.com/api/api_open.php")
        let m = ADNetworkManager(baseURL: url)
        
        // 设置AFN能接受的dataType
        //        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as! Set<String>
        m.responseSerializer.acceptableContentTypes = Set<String>(arrayLiteral: "application/json", "text/json", "text/javascript", "text/plain")
        return m
    }()
    
    class func shared() -> ADNetworkManager {
        return m
    }
}
