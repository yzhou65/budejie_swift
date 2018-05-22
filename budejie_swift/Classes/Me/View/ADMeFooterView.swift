//
//  ADMeFooterView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SafariServices

private let maxCols: Int = 5    // 一行最多4列方格
private let margin: CGFloat = 5

class ADMeFooterView: UIView, SFSafariViewControllerDelegate {
    
    var footerHeight: CGFloat = 0
    
//    init(squares: [ADSquare]) {
//        super.init(frame: CGRect.zero)
//        
//        self.backgroundColor = UIColor.clear
//        self.createSquareButtons(with: squares)
//    }
    
    init(squares: [Square]) {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        self.createSquareButtons(with: squares)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    private func createSquareButtons(with squares: [ADSquare]) {
    
    private func createSquareButtons(with squares: [Square]) {
        //宽高
        let buttonW: CGFloat = (ADScreenW - margin * CGFloat(maxCols - 1)) / CGFloat(maxCols)
        let buttonH: CGFloat = buttonW
        
        for i in 0..<squares.count {
            // 创建按钮
            let btn = ADSquareButton(type: UIButtonType.custom)
            
            // 监听
            btn.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControlEvents.touchUpInside)
            btn.square = squares[i]
            self.addSubview(btn)
            
            // 计算frame
            let col = i % maxCols
            let row = i / maxCols
            btn.frame = CGRect(x: CGFloat(col) * (buttonW + margin), y: CGFloat(row) * (buttonW + margin), width: buttonW, height: buttonH)
        }
        
        //计算footerView的高度
        //总页数 == (总个数 ＋ 每页最大数 － 1) / 每页最大数
        let rows = (squares.count + maxCols - 1) / maxCols
        self.height = CGFloat(rows) * (buttonH + margin)
        self.footerHeight = CGFloat(rows) * (buttonH + margin)
//        print("rows: \(rows), height: \(self.height)")
    }
    
    @objc private func buttonTapped(_ btn: ADSquareButton) {
        if !btn.square.url.hasPrefix("http") {
            return
        }
        
        let webVC = ADWebViewController()
        webVC.url = btn.square.url
        webVC.title = btn.square.name
        
//        let safariVC = SFSafariViewController(url: URL(string: btn.square.url)!)
//        safariVC.delegate = self
        
        // 取出当前导航控制器
        let tabBarVC = UIApplication.shared.keyWindow!.rootViewController as! UITabBarController
        let nav = tabBarVC.selectedViewController as! UINavigationController
        nav.pushViewController(webVC, animated: true)
//        nav.pushViewController(safariVC, animated: true)
    }
    
    // MARK: - SafariDelegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        let tabBarVC = UIApplication.shared.keyWindow!.rootViewController as! UITabBarController
        let nav = tabBarVC.selectedViewController as! UINavigationController
        nav.popViewController(animated: true)
    }
    
    // MARK: - 懒加载
    private lazy var networkManager = ADNetworkManager.shared()
}
