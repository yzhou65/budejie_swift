//
//  ADFriendTrendsViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/25/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

/**
 *手动给当前控制器设置xib的时候, 要先在File's Owner中关联控制器名称, 然后把File's Owner的view拖线到xib的view中, 否则什么也看不到
 *
 * 在xib或storyboard里, 如果想要UILabel里的静态写死内容能换行可以使用输入control或option+enter(不能使用\n), 也可以联合\n用代码来写死, 动态换行就是设置lines == 0
 */
class ADFriendTrendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏的内容
        self.configureNav()
        
    }
    
    // 设置导航栏内容
    private func configureNav() {
        self.navigationItem.title = "我的关注"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: "friendsRecommentIcon", highlightedImage: "friendsRecommentIcon-click", target: self, action: #selector(friendsClick))
        
        //设置背景色. 不要在ADTabBarController里设置, 否则导致控制器提前创建, 而非点击使用时才创建
        self.view.backgroundColor = adGlobalColor()
    }
    
    // MARK: - 按钮监听
    @objc private func friendsClick() {
        self.navigationController?.pushViewController(ADRecommendViewController(), animated: true)
    }
    
    @IBAction func loginRegister(_ sender: UIButton) {
        // 使用ADLoginRegisterViewController()构造方法能自动加载其同名xib
        self.present(ADLoginRegisterViewController(), animated: true, completion: nil)
    }
    

}
