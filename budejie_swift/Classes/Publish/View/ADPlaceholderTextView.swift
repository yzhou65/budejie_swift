//
//  ADPlaceholderTextView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/7/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADPlaceholderTextView: UITextView {
    // MARK: - 成员变量
    var placeholderText: String? {
        didSet {
            self.placeholderLabel.text = placeholderText
            self.setNeedsLayout()
        }
    }
    var placeholderColor: UIColor? {
        didSet {
            self.placeholderLabel.textColor = placeholderColor!
        }
    }
    
    override var font: UIFont? {
        didSet {
            self.placeholderLabel.font = font!
            self.setNeedsLayout()
        }
    }
    
    override var text: String! {
        didSet {
            self.textChanged()
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            self.textChanged()
        }
    }
    
    var postButtonBlock: ((_ hasWord: Bool) -> ())?
    
    
    /**
     setNeedsDisplay: 会在恰当的时候自动调用drawRect
     setNeedsLayout：会在恰当的时候自动调用layoutSubviews
     */
    
    // MARK: - init, deinit
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // 垂直方向上永远有弹簧效果
        self.alwaysBounceVertical = true
        
        // 默认字体
        self.font = UIFont.systemFont(ofSize: 15)
        
        // 默认的占位文字颜色
        self.placeholderColor = UIColor.gray
        
        // 监听文字改变. 也可以在外面用delegate监听textChanged
//        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    /**
     更新占位文字的尺寸
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x
        self.placeholderLabel.sizeToFit()
    }
    
    // MARK: - 通知
    @objc private func textChanged() {
        self.placeholderLabel.isHidden = self.hasText
        if let post = self.postButtonBlock {
            post(self.hasText)
        }
    }
    
    // MARK: - 懒加载
    lazy private(set) var placeholderLabel: UILabel = {
        //添加一个用来显示占位文字的label
        let placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0; //能自动换行
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        self.addSubview(placeholderLabel)
        return placeholderLabel
    }()
}
