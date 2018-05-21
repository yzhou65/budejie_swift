//
//  ADCommentCell.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/6/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADCommentCell: UITableViewCell, RegisterCellNib {
    // MARK: - 子控件
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var genderView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - 成员变量
//    var comment: ADComment? {
//        didSet {
////            let c = comment!
//            self.profileImageView.setProfileImage(with: comment!.user!.profile_image!)
//            if comment!.user!.sex == ADUserGender.male.rawValue {
//                self.genderView.image = UIImage(named: "Profile_manIcon")
//            } else {
//                self.genderView.image = UIImage(named: "Profile_womanIcon")
//            }
//
//            self.contentLabel.text = comment!.content
//            self.usernameLabel.text = comment!.user!.username
//            self.likeCountLabel.text = "\(comment!.like_count!)"
//            if comment!.voiceuri == nil || comment!.voiceuri!.isEmpty {  //注意如果没有音频，服务器一般返回的voiceuri是个空串，而不是nil
//                self.voiceBtn.isHidden = true
//            }
//            else {
//                self.voiceBtn.isHidden = false
//                self.voiceBtn.setTitle("\(comment!.voicetime!)", for: UIControlState.normal)
//            }
//        }
//    }
    
    var comment: Comment = Comment() {
        didSet {
            self.profileImageView.setProfileImage(with: comment.user.profile_image)
            if comment.user.sex == ADUserGender.male.rawValue {
                self.genderView.image = UIImage(named: "Profile_manIcon")
            } else {
                self.genderView.image = UIImage(named: "Profile_womanIcon")
            }
            
            self.contentLabel.text = comment.content
            self.usernameLabel.text = comment.user.username
            self.likeCountLabel.text = "\(comment.like_count)"
            if comment.voiceuri.isEmpty {  //注意如果没有音频，服务器一般返回的voiceuri是个空串，而不是nil
                self.voiceBtn.isHidden = true
            }
            else {
                self.voiceBtn.isHidden = false
                self.voiceBtn.setTitle("\(comment.voicetime)", for: UIControlState.normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView = UIImageView(image: UIImage(named: "mainCellBackground"))
    }
    
    
    // MARK: - menuController相关
    override var canBecomeFirstResponder: Bool { return true }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

}
