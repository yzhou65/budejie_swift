//
//  ADComment.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/5/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADComment: NSObject {
    /** id */
    var id: String?
    /** 音频时长 */
    var voicetime: NSNumber?
    /** 音频文件路径 */
    var voiceuri: String?
    /** 评论的文字内容 */
    var content: String?
    /** 被点赞的数量 */
    var like_count: NSNumber?
    /** 用户 */
    var user: ADUser?
}
