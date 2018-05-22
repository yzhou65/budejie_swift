//
//  ADTopicVoiceView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/5/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADTopicVoiceView: UIView {
    // MARK: - 子控件, 成员变量
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playcountLabel: UILabel!
    @IBOutlet weak var voicetimeLabel: UILabel!
    
    var topic: Topic = Topic() {
        didSet {
            self.imageView.sd_setImage(with: URL(string: topic.image1))
            
            //播放次数
            self.playcountLabel.text = "\(topic.playcount)播放"
            
            //播放时长
            self.voicetimeLabel.text = String(format: "%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60)  //分和秒都要2位，不满2位用0填补。
        }
    }
    
    // MARK: - 初始化,设置
    class func voiceView() -> ADTopicVoiceView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last as! ADTopicVoiceView
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)  //这个很重要。如果不设置autoresizing，就会导致picture的尺寸与下面设置的不一样（可能会超出范围）
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicture)))
    }
    

    @objc private func showPicture() {
        let showPictureVC = ADShowPictureViewController(topic: self.topic)
        
        //当前类是个UIView，没有presentViewController方法，所以要拿到keyWindow的根控制器
        UIApplication.shared.keyWindow!.rootViewController?.present(showPictureVC, animated: true, completion: nil)
    }

}
