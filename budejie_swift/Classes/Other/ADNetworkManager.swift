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
    
    private init() {
        super.init(baseURL: nil, sessionConfiguration: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static var m: ADNetworkManager = {
        // note: baseURL结尾必须是 "/"
        let url = URL(string: "https://api.budejie.com/api/api_open.php")
//        let m = ADNetworkManager(baseURL: url)
        let m = ADNetworkManager()
        
        // 设置AFN能接受的dataType
        m.responseSerializer.acceptableContentTypes = Set<String>(arrayLiteral: "application/json", "text/json", "text/javascript", "text/plain")
        return m
    }()
    
    class func shared() -> ADNetworkManager {
        return m
    }
}


