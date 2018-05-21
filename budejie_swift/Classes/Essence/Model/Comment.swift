//
//  Comment.swift
//  budejie_swift
//
//  Created by Yue Zhou on 5/20/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import HandyJSON

struct Comment: HandyJSON {
    /** id */
    var id: String = ""
    /** 音频时长 */
    var voicetime: Int = 0
    /** 音频文件路径 */
    var voiceuri: String = ""
    /** 评论的文字内容 */
    var content: String = ""
    /** 被点赞的数量 */
    var like_count: Int = 0
    /** 用户 */
    var user = User()
}
