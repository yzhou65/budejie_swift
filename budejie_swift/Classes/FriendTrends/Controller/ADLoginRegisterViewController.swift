//
//  ADLoginRegisterViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADLoginRegisterViewController: UIViewController {
    @IBOutlet weak var loginViewLeftMargin: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 可以用运行时获得_placeholderLabel这个key. 通过kvc和.textColor可以获取到占位字符串的label的颜色属性, 在ADTextField进行自定义操作
//        ADTextField.printIvars()
//        ADTextField.printProperties()
    }
    
    // statusBar的颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - 按钮监听
    
    @IBAction func showLoginOrRegister(_ sender: UIButton) {
        if self.loginViewLeftMargin.constant == 0 {
            self.loginViewLeftMargin.constant -= self.view.width
            sender.isSelected = true
        } else {
            self.loginViewLeftMargin.constant = 0
            sender.isSelected = false
        }
        
        UIView.animate(withDuration: 0.25) {
            // 约束改变的时候需要调用
            self.view.layoutIfNeeded()
        }
    }
    

    @IBAction func back(_ sender: Any) {
        // 先退出键盘再dismiss
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
