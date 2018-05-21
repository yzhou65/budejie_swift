//
//  ADAddTagViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/11/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

class ADAddTagViewController: UIViewController, UITextFieldDelegate {
    
    var tagsBlock: ((_ tags: [String]) -> ())?

    // MARK: - 初始设定
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNav()
        
        self.view.addSubview(self.contentView)
        self.contentView.addSubview(self.textField)
        
        self.configTags()
    }
    
    
    private func configNav() {
        self.view.backgroundColor = UIColor.white
        self.title = "添加标签"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.done, target: self, action: #selector(done))
    }
    
    private func configTags() {
        let tags = self.tags
        for tag in tags {
            self.textField.text = tag
            self.addButtonClick()
        }
    }
    
    // MARK: - 懒加载
    lazy var tags = [String]()
    
    lazy var tagButtons = [ADTagButton]()
    
    /** 添加按钮 */
    lazy var addButton: UIButton = {
        let ab = ADTagButton(type: UIButtonType.custom)
        ab.width = self.contentView.width
        ab.height = 35
        ab.backgroundColor = adColor(74, 139, 209)
        ab.setTitleColor(UIColor.white, for: UIControlState.normal)
        ab.addTarget(self, action: #selector(addButtonClick), for: UIControlEvents.touchUpInside)
        ab.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
//        ab.contentMode = UIViewContentMode.left; //contentMode一般只用于image，文字不合用

        // 让按钮内部的文字和图片都左对齐
        ab.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        ab.contentEdgeInsets = UIEdgeInsets(top: 0, left: ADTagMargin, bottom: 0, right: ADTagMargin)
        self.contentView.addSubview(ab)
        return ab
    }()
    
    /** 内容 */
    lazy var contentView: UIView = {
        let cv = UIView()
        cv.x = ADTagMargin
        cv.width = self.view.width - 2 * cv.x
        cv.y = 64 + ADTagMargin
        cv.height = ADScreenH
        
//        cv.backgroundColor = UIColor.red
//        self.view.addSubview(cv)
        return cv
    }()
    
    /** 文本输入框 */
    lazy var textField: ADTagTextField = {
        let tf = ADTagTextField()
        tf.width = self.contentView.width
        tf.deleteBlock = { [weak self] in
            if self!.textField.hasText {
                return
            }
            self!.tagButtonClick(self!.tagButtons.last!)
        }
        
        tf.delegate = self

        //textField的监听不宜使用代理，因为漏洞多且中文适配差。textField继承自UIControll，所以可以直接使用addTarget
        tf.addTarget(self, action: #selector(textDidChange), for: UIControlEvents.editingChanged)
        tf.becomeFirstResponder()
//        self.contentView.addSubview(tf)
        return tf
    }()
    
    
    // MARK: - 监听文字变化
    @objc private func textDidChange() {
        //更新标签和文本框的frame
        self.updateTextFieldFrame()
        
        if self.textField.hasText {  // 有文字
            self.addButton.isHidden = false
            self.addButton.y = self.textField.frame.maxY + ADTagMargin
            self.addButton.setTitle("添加标签\(self.textField.text!)", for: UIControlState.normal)
            
            // 获得最后一个字符
            let text = self.textField.text
            let lastCharacter = text!.last!
            
            if String(lastCharacter) == "," || String(lastCharacter) == "，" {
                let start = text!.startIndex
                let end = text!.index(text!.endIndex, offsetBy: -1)
                self.textField.text = text!.substring(with: Range<String.Index>.init(uncheckedBounds: (lower: start, upper: end)))  // 去除逗号
                self.addButtonClick()
            }
        }
        else {  // 没有文字了
            // 隐藏"添加标签"的按钮
            self.addButton.isHidden = true
        }
        
    }
   
    
    // MARK: - 按钮响应
    @objc private func done() {
        let tags = (self.tagButtons as NSArray).value(forKey: "currentTitle") as! [String]
        if let block = self.tagsBlock {
            block(tags)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /**
    * 添加标签
    */
    @objc private func addButtonClick() {
        if self.tagButtons.count == 5 {
            SVProgressHUD.showError(withStatus: "最多添加5个标签")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            return
        }
        
        // 添加一个"标签按钮"
        let tagButton = ADTagButton(type: UIButtonType.custom)
        tagButton.addTarget(self, action: #selector(tagButtonClick(_:)), for: UIControlEvents.touchUpInside)
        tagButton.setTitle(self.textField.text, for: UIControlState.normal)
        self.contentView.addSubview(tagButton)
        self.tagButtons.append(tagButton)
        
        // 清空textField文字
        self.textField.text = ""
        self.textField.isHidden = true
        
        // 更新标签按钮的frame
        self.updateTagButtonFrame()
        self.updateTextFieldFrame()
    }
    
    @objc private func tagButtonClick(_ btn: ADTagButton) {
        btn.removeFromSuperview()
        if let index = self.tagButtons.index(of: btn) {
            self.tagButtons.remove(at: index)
        }

        // 重新更新所有标签按钮的frame
        UIView.animate(withDuration: 0.25) { 
            self.updateTagButtonFrame()
            self.updateTextFieldFrame()
        }
    }
    
    
    // MARK: - 工具方法: 更新frames
    private func updateTagButtonFrame() {
        for i in 0..<self.tagButtons.count {
            let btn = self.tagButtons[i]
            if i == 0 {
                btn.origin = CGPoint.zero
            }
            else {
                let lastBtn = self.tagButtons[i - 1]
                
                // 计算当前行剩余的宽度
                let leftWidth = lastBtn.frame.maxX + ADTagMargin
                let rightWidth = self.contentView.width - leftWidth
                if rightWidth >= btn.width {    // 显示在当前行
                    btn.origin = CGPoint(x: leftWidth, y: lastBtn.y)
                } else {    // 显示在下一行
                    btn.origin = CGPoint(x: 0, y: lastBtn.frame.maxY + ADTagMargin)
                }
            }
        }
    }
    
    private func updateTextFieldFrame() {
        //最后一个标签按钮
        let lastTagButton = self.tagButtons.last
        if lastTagButton == nil {
            self.textField.origin = CGPoint(x: ADTagMargin, y: 0)
            return
        }
        
        let leftWidth = lastTagButton!.frame.maxX + ADTagMargin
        
        // 更新textField的frame
        if self.contentView.width - leftWidth >= self.textFieldWidth() {
            self.textField.y = lastTagButton!.y
            self.textField.x = lastTagButton!.frame.maxX + ADTagMargin
        }
        else {
            self.textField.x = 0
            self.textField.y = lastTagButton!.frame.maxY + ADTagMargin
        }
    }
    
    /**
     textField的文字宽度
     */
    private func textFieldWidth() -> CGFloat {
        let textRect = NSString(string: self.textField.text!).boundingRect(with: self.textField.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: self.textField.font!], context: nil)
        return max(100, textRect.width)
    }

    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.hash > 0 {
            self.addButtonClick()
        }
        return true
    }
}
