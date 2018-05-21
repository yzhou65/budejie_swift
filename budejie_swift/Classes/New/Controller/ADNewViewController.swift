//
//  ADNewViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/25/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADNewViewController: ADEssenceViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏的内容
        self.configureNav()
        
    }
    
    // 设置导航栏内容
    private func configureNav() {
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "MainTitle"))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: "MainTagSubIcon", highlightedImage: "MainTagSubIconClick", target: self, action: #selector(tagTapped))
        
        //设置背景色. 不要在ADTabBarController里设置, 否则导致控制器提前创建, 而非点击使用时才创建
        self.view.backgroundColor = adGlobalColor()
    }
    
    @objc private func tagTapped() {
        adPrint(#function)
    }

}
