//
//  ADTopicCell.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/5/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ADTopicCell: UITableViewCell {
    // MARK: - 成员变量, 子控件
    /** 头像 */
    @IBOutlet weak var profileImageView: UIImageView!
    /** 昵称 */
    @IBOutlet weak var nameLabel: UILabel!
    /** 创建时间 */
    @IBOutlet weak var createTimeLabel: UILabel!
    /** 顶 */
    @IBOutlet weak var dingBtn: UIButton!
    /** 踩 */
    @IBOutlet weak var caiBtn: UIButton!
    /** 分享 */
    @IBOutlet weak var shareBtn: UIButton!
    /** 评论 */
    @IBOutlet weak var commentBtn: UIButton!
    /** 新浪加V */
    @IBOutlet weak var sina_vView: UIImageView!
    /** 帖子的文字内容 */
    @IBOutlet weak var text_label: UILabel!
    /** 最热评论的内容 */
    @IBOutlet weak var topCmtContentLabel: UILabel!
    /** 最热评论的整体 */
    @IBOutlet weak var topCmtView: UIView!
    
    @IBOutlet weak var bottomToolBar: UIView!
    
    var topic: ADTopic? {
        didSet {
//            print(topic!)
            // 新浪vip
//            let t = topic!
            self.sina_vView.isHidden = !topic!.sina_v
            
            //设置头像
            self.profileImageView.setProfileImage(with: topic!.profile_image!)
            
            //设置名字
            self.nameLabel.text = topic!.name!
            
            //设置帖子的创建时间
            self.createTimeLabel.text = topic!.createTime!
            
            //设置按钮文字
            self.setButtonTitle(with: self.dingBtn, count: topic!.ding!.intValue, placeholder: "顶")
            self.setButtonTitle(with: self.caiBtn, count: topic!.cai!.intValue, placeholder: "踩")
            self.setButtonTitle(with: self.shareBtn, count: topic!.favourite!.intValue, placeholder: "分享")
            self.setButtonTitle(with: self.commentBtn, count: topic!.comment!.intValue, placeholder: "评论")
            
            //设置帖子的文字内容
            self.text_label.text = topic!.text!
            
            //根据帖子类型添加对应的内容到cell的中间。在“全部”中，cell的循环利用可能导致图片声音视频和段子显示混乱，所以要显示自己，隐藏其他。
            if topic!.type!.intValue == ADTopicType.picture.rawValue { //图片帖子
                self.pictureView.isHidden = false
                self.pictureView.topic = topic;
                self.pictureView.frame = topic!.pictureFrame!
                
                self.voiceView.isHidden = true
                self.videoView.isHidden = true
            }
            else if topic!.type!.intValue == ADTopicType.voice.rawValue { //声音帖子
                self.voiceView.isHidden = false
                self.voiceView.topic = topic
                self.voiceView.frame = topic!.voiceFrame!
                
                self.pictureView.isHidden = true
                self.videoView.isHidden = true
            }
            else if topic!.type!.intValue == ADTopicType.video.rawValue { //视频帖子
                self.videoView.isHidden = false
                self.videoView.topic = topic;
                self.videoView.frame = topic!.videoFrame!
                
                self.voiceView.isHidden = true
                self.pictureView.isHidden = true
            }
            else { //段子帖子
                //在全部中会循环利用cell，所以显示段子时要隐藏其他元素，然后在显示图片声音视频时再显示回来。
                self.videoView.isHidden = true
                self.voiceView.isHidden = true
                self.pictureView.isHidden = true
            }
//
            //处理最热评论
            if topic!.topComment == nil {
                self.topCmtView.isHidden = true
                return
            }
            self.topCmtView.isHidden = false //循环利用：隐藏过的要重新显现
          
            // 给最热评论设置文字
//            let tl = topic!.topComment
            self.topCmtContentLabel.text = "\(topic!.topComment!.user!.username!): \(topic!.topComment!.content!)"
        }
    }
    
    // MARK: - life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView = UIImageView(image: UIImage(named: "mainCellBackground"))
        
        self.commentBtn.reactive.controlEvents(.touchUpInside).observeValues { (_) in
            let commentVC = ADCommentViewController()
            commentVC.topic = self.topic
            
            // 拿到navigationController, push这个commentVC
            let tabBarVC = UIApplication.shared.keyWindow!.rootViewController as! ADTabBarController
            let nav = tabBarVC.selectedViewController as! UINavigationController
            nav.pushViewController(commentVC, animated: true)
        }
    }
    
    class func cell() -> ADTopicCell {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first! as! ADTopicCell
    }
    
    override var frame: CGRect {
        
        get{ return super.frame }
        set(f) {
            var fm = f
//            fm.size.height -= ADTopicCellMargin; //不要这样写,隐患：如果不停调用setFrame，那么其高度会不断减少
            
            if let topic = self.topic {
                fm.size.height = topic.topicHeight() - ADTopicCellMargin
//                print("\(topic.name!): \(self.bottomToolBar.y)....\(self.text_label.frame.maxY)")
            }
            fm.origin.y += ADTopicCellMargin
            super.frame = fm
        }
    }
    
    // MARK: - 按钮相关
    /**
     处理顶、踩、分享和评论的个数的格式。
     */
    private func setButtonTitle(with button: UIButton, count: Int, placeholder: String) {
        var placeholder = placeholder
        if count > 10000 {
            placeholder = String(format: ".1f万", Float(count) / 10000.0)
        }
        else if count > 0 {
            placeholder = "\(count)"
        }
        button.setTitle(placeholder, for: UIControlState.normal)
    }

    
    @IBAction func more(_ sender: Any) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        ac.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (_) in
            
        }))
        ac.addAction(UIAlertAction(title: "收藏", style: UIAlertActionStyle.init(rawValue: 0)!, handler: { (_) in
            
        }))
        ac.addAction(UIAlertAction(title: "举报", style: UIAlertActionStyle.init(rawValue: 0)!, handler: { (_) in
            
        }))
        

        // 拿到navigationController, modally present这个commentVC
        let tabBarVC = UIApplication.shared.keyWindow!.rootViewController as! ADTabBarController
        let nav = tabBarVC.selectedViewController as! UINavigationController
        nav.present(ac, animated: true, completion: nil)
    }
    
//    @IBAction func viewComments(_ sender: Any) {
//        let commentVC = ADCommentViewController()
//        commentVC.topic = self.topic
//        
//        // 拿到navigationController, push这个commentVC
//        let tabBarVC = UIApplication.shared.keyWindow!.rootViewController as! ADTabBarController
//        let nav = tabBarVC.selectedViewController as! UINavigationController
//        nav.pushViewController(commentVC, animated: true)
//    }

    // 此方法会导致cell上的所有子控件都无法接收响应
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        return self
//    }
    

    // MARK: - 懒加载
    /** 图片帖子中间的内容 */
     lazy var pictureView: ADTopicPictureView = {
        let pic = ADTopicPictureView.pictureView()
        self.contentView.addSubview(pic)
        return pic
    }()
    
    /** 声音帖子中间的内容 */
    private lazy var voiceView: ADTopicVoiceView = {
        let voice = ADTopicVoiceView.voiceView()
        self.contentView.addSubview(voice)
        return voice
    }()
    
    /** 视频帖子中间的内容 */
    lazy var videoView: ADTopicVideoView = {
        let video = ADTopicVideoView.videoView()
        self.contentView.addSubview(video)
        return video
    }()

    
    // MARK: - 时间相关的例子
    /**
     处理时间的测试例子。For debugging。
     */
    private func testDate(create_time: String) {
        //日期格式化类
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss" //指定解析日期格式
    
        //当前时间
        let now = Date()
        //发帖时间
        let create = fmt.date(from: create_time)!
    
        //日历
        let calendar = Calendar.current
    
        //比较时间. NSCalendar的components：方法能直接计算两个时间的年月日时分秒差值
        let cmps = calendar.dateComponents(Set<Calendar.Component>.init(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second), from: create, to: now)
        print("\(String(describing: cmps.month))/\(String(describing: cmps.day))/\(String(describing: cmps.year))")
    
        // 使用NSCalendar获取年月日
        let year = calendar.component(Calendar.Component.year, from: now)
        let month = calendar.component(Calendar.Component.month, from: now)
        let day = calendar.component(Calendar.Component.day, from: now)
        print("\(month)/\(day)/\(year)")
    }
}
