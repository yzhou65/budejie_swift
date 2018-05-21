//
//  Notification+ADExtension.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/8/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import Foundation

extension NotificationCenter {
    static func post(myNotification name: ADNotification, object: Any?) {
        NotificationCenter.default.post(name: name.notificationName, object: object)
    }
}
