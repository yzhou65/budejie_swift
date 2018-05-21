//
//  ADPostWordViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/7/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADPostWordViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNav()
        self.configTextView()
    }

    // 设置导航条
    private func configNav() {
        self.title = "发表文字"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: UIBarButtonItemStyle.done, target: self, action: #selector(post))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 强制更新界面
//        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func configTextView() {
        self.view.addSubview(textView)
    }

    // MARK: - 按钮监听
    @objc private func cancel() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func post() {
        adPrint(#function)
    }
    
    
    // MARK: UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        (textView as! ADPlaceholderTextView).placeholderLabel.isHidden = textView.hasText
    }

    
    // MARK: - 懒加载
    lazy private(set) var textView: ADPlaceholderTextView = {
//        let textView = ADPlaceholderTextView(frame: self.view.bounds)
        let textView: ADPlaceholderTextView = ADPlaceholderTextView(frame: self.view.bounds, textContainer: nil)
        textView.placeholderText = "把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。"
        textView.placeholderColor = UIColor.gray.withAlphaComponent(0.7)
        
//        textView.postButtonBlock = { (hasWord: Bool) in
//            self.navigationItem.rightBarButtonItem?.isEnabled = hasWord
//        }
        textView.delegate = self
        
        // 把自定义的ADAddToolBar放到键盘上方
        textView.inputAccessoryView = ADAddToolBar.bar()
        
        // 一进来就弹出键盘
        textView.becomeFirstResponder()
        
        return textView
    }()
     

    /*
     UITextField *textField默认的情况
     1.只能显示一行文字
     2.有占位文字
     
     UITextView *textView默认的情况
     2.能显示任意行文字
     2.没有占位文字
     
     文本输入控件,最终希望拥有的功能
     1.能显示任意行文字
     2.有占位文字
     
     最终的方案:
     1.继承自UITextView
     2.在UITextView能显示任意行文字的基础上,增加"有占位文字"的功能
     */

}
