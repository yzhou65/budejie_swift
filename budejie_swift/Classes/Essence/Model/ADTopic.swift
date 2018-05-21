//
//  ADTopic.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/4/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTopic: NSObject {
    //MARK: - 成员变量
    /** id */
    var id: String?
    /** 名称 */
    var name: String?
    /** 头像 */
    var profile_image: String?
    /** 发帖时间 */
    var create_time: String? {
        didSet {
            //日期格式化类
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let create = fmt.date(from: create_time!)!
            if create.isThisYear() {
                if create.isToday() {
                    let comps = Date().timeElapsed(from: create)
                    if comps.hour! >= 1 {   // 时间差距 >= 1小时
                        self.createTime = "\(comps.hour!)小时前"
                    }
                    else if comps.minute! >= 1 { // 1小时 > 时间差距 >= 1分钟
                        self.createTime = "\(comps.minute!)分钟前"
                    }
                    else {  // 1分钟 > 时间差距
                        self.createTime = "刚刚"
                    }
                }
                else if create.isYesterday() {
                    fmt.dateFormat = "昨天 HH:mm:ss"
                    self.createTime = fmt.string(from: create)
                } else {
                    fmt.dateFormat = "MM-dd HH:mm:ss"
                    self.createTime = fmt.string(from: create)
                }
            }
            else {  // 非今年
                createTime = create_time
            }
        }
    }
    
    /** 按一定格式自定义的发帖时间 */
    var createTime: String?
    /** 文字内容 */
    var text: String?
    /** 被顶的数量 */
    var ding: NSNumber?
    /** 被踩的数量 */
    var cai: NSNumber?
    /** 被转发的数量 */
    var favourite: NSNumber?
    /** 评论的数量 */
    var comment: NSNumber?
    /** 是否为新浪加V用户 */
    var sina_v: Bool = false
//    @property(assign, nonatomic, getter=isSina_v) BOOL sina_v;
    
    /** 图片的宽度 */
    var width: NSNumber? {
        didSet {
//            picWidth = CGFloat(width!.floatValue)
        }
    }
    var picWidth: CGFloat {
        
        return width != nil ? CGFloat(width!.floatValue) : 0
    }
    /** 图片的高度 */
    var height: NSNumber? {
        didSet {
//            picHeight = CGFloat(height!.floatValue)
        }
    }
    var picHeight: CGFloat {
        return height != nil ? CGFloat(height!.floatValue) : 0
    }
    /** 小图片的URL */
    var small_image: String?
    /** 大图片的URL */
    var large_image: String?
    /** 中图片的URL */
    var middle_image: String?
    /** 帖子的类型 */
    var type: NSNumber?
    /** 音频时长 */
    var voicetime: NSNumber?
    /** 视频时长 */
    var videotime: NSNumber?
    /** 播放次数 */
    var playcount: NSNumber?
    
    /** 最热评论（YZComment模型） */
    var top_cmt: [[String: Any]]? {
        didSet {
            if top_cmt!.count > 0 {
                self.topComment = ADComment.object(with: top_cmt![0], replacedKeyNames: nil)
                self.topComment!.user = ADUser.object(with: top_cmt![0]["user"] as! [String : Any], replacedKeyNames: nil)
            }
        }
    }
    
    //百思不得姐服务器返回的最热评论虽然是个NSArray，但是长度总是1，所以没必要用数组，转而使用YZComment
    var topComment: ADComment?
    
    /** qzone_uid */
    var qzone_uid: String?
    
    
    /** 额外的辅助属性 */
    /** cell的高度.写了readonly以后，系统就不会再自动生成_cellHeight成员变量了 */
    private(set) var cellHeight: CGFloat = 0

    /** 图片控件的frame */
    private(set) var pictureFrame: CGRect?

    /** 图片是否太大 */
    var isBigPicture: Bool = false
    
    /** 图片的下载进度 */
    var pictureProgress: CGFloat = 0
    
    /** 声音控件的frame */
    private(set) var voiceFrame: CGRect?
    
    /** 视频控件的frame */
    private(set) var videoFrame: CGRect?
    
    /**
     模型属性：服务器返回的key
     */
    static let replacedKeyFromPropertyName = ["small_image": "image0", "large_image": "image1", "middle_image": "image2"]
    
    
    // MARK: - 计算topicCell高度
    
    // 计算一个topicCell的高度
    func topicHeight() -> CGFloat {
        if self.cellHeight != 0 {
            return self.cellHeight
        }
        
        // 文字的最大尺寸
        let maxSize = CGSize(width: UIScreen.main.bounds.size.width - 2 * self.ADTopicCellMargin, height: CGFloat(MAXFLOAT))
        // 计算文字高度
        let textH: CGFloat = self.text!.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil).size.height
        
        // cell的高度
        var ch = self.ADTopicCellTextY + textH + self.ADTopicCellMargin * 2
        
        // 根据帖子类型计算cell的高度
        if self.type!.intValue == ADTopicType.picture.rawValue {  // 图片帖子
            if self.picWidth != 0 && self.picHeight != 0 {
                let pictureW = maxSize.width
                var pictureH: CGFloat = pictureW * self.picHeight / self.picWidth
                
                
                if pictureH > self.ADTopicCellPictureMaxH {
                    pictureH = self.ADTopicCellPictureLimitH
                    self.isBigPicture = true  // 大图
                }
                
                // 计算图片控件的frame
                let pictureX = self.ADTopicCellMargin
                let pictureY = self.ADTopicCellTextY + textH + self.ADTopicCellMargin * 2
                self.pictureFrame = CGRect(x: pictureX, y: pictureY, width: pictureW, height: pictureH)
                ch += pictureH + self.ADTopicCellMargin
            }
        }
        else if self.type!.intValue == ADTopicType.voice.rawValue {     // 声音帖子
            let voiceX = self.ADTopicCellMargin
            let voiceY = self.ADTopicCellTextY + textH + self.ADTopicCellMargin * 2
            let voiceW = maxSize.width
            let voiceH = voiceW * self.picHeight / self.picWidth
            self.voiceFrame = CGRect(x: voiceX, y: voiceY, width: voiceW, height: voiceH)
            ch += voiceH + self.ADTopicCellMargin
        }
        else if self.type!.intValue == ADTopicType.video.rawValue {     // 视频帖子
            let videoX = self.ADTopicCellMargin
            let videoY = self.ADTopicCellTextY + textH + self.ADTopicCellMargin * 2
            let videoW = maxSize.width
            let videoH = videoW * self.picHeight / self.picWidth
            self.videoFrame = CGRect(x: videoX, y: videoY, width: videoW, height: videoH)
            ch += videoH + self.ADTopicCellMargin
        }
        else {
            ch += self.ADTopicCellMargin * 2
        }
        
        //如果有最热评论，还要将最热评论的高度计入，否则最热评论会挡住帖子内容
        if let topComment = self.topComment {
            let top = "\(topComment.user!.username ?? ""): \(topComment.content ?? "")"
            let topH = top.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13)], context: nil).size.height
            
            ch += self.ADTopicCellTopCmtTitleH + topH + self.ADTopicCellMargin
        }
        
        //cellHeight要加上底部工具条的高度
        ch += self.ADTopicCellBottomBarH + self.ADTopicCellMargin * 1
        self.cellHeight = ch
        return ch
    }
//    }()
}
