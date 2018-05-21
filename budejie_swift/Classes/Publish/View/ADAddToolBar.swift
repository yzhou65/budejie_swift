//
//  ADAddToolBar.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/10/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

class ADAddToolBar: UIView {

    @IBOutlet weak var topView: UIView!
    
    // MARK: - 构造,初始化
    class func bar() -> ADAddToolBar {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.last as! ADAddToolBar
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topView.addSubview(self.addButton)
    }

    // MARK: - 懒加载
    private lazy var tagLabels = [UILabel]()
    
    lazy var addButton: UIButton = {
        //添加一个加号按钮
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "tag_add_icon"), for: UIControlState.normal)
        addButton.frame = CGRect(origin: CGPoint(x: self.ADTagMargin, y: 0), size: addButton.currentImage!.size)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: UIControlEvents.touchUpInside)
        return addButton
    }()
    
    
    // MARK: - 按钮响应
    @objc private func addButtonTapped() {
        
        let addTagVC = ADAddTagViewController()
        addTagVC.tagsBlock = { [weak self](tags: [String]) in
            self?.createTagLabels(with: tags)
        }
        
        // 得到所有tagLabels里每个tagLabel.text
        let tags = (self.tagLabels as NSArray).value(forKey: "text") as! [String]
        addTagVC.tags = tags
        let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as! ADTabBarController
        
        // publish按钮没有select一个控制器,而是present一个nav(nav里有ADPostWordViewController), 所以
        //        let nav = tabBarVC.selectedViewController as! UINavigationController  // 错误
        let nav = tabBarVC.presentedViewController as! UINavigationController
        nav.pushViewController(addTagVC, animated: true)
        
//        //如果a modal出b
//        //[a presentViewController:b animated:YES completion:nil]
//        //a.presentedViewController == b。 b.presentingViewController == a
    }
    
    
    private func createTagLabels(with tags: [String]) {
        self.tagLabels.forEach { (label) in
            label.removeFromSuperview()
        }
        self.tagLabels.removeAll()
        
        for i in 0..<tags.count {
            let tagLabel = UILabel()
            self.tagLabels.append(tagLabel)
            tagLabel.backgroundColor = adColor(74, 139, 209)
            tagLabel.textAlignment = NSTextAlignment.center
            tagLabel.text = tags[i]
            
            // 要先设置文字和字体, 再进行计算
            tagLabel.font = UIFont.systemFont(ofSize: 14.0)
            tagLabel.width += 2 * ADTagMargin
            tagLabel.height = ADTagH
            tagLabel.textColor = UIColor.white
            tagLabel.sizeToFit()
            
            self.topView.addSubview(tagLabel)
            
            // 设置位置
            if i == 0 { // 最前面的标签
                tagLabel.x = 0
                tagLabel.y = 0
            } else {  // 其他标签
                let previousLabel = self.tagLabels[i - 1]
                
                // 计算当前左右和右边的宽度
                let leftWidth = previousLabel.frame.maxX + ADTagMargin
                let rightWidth = self.topView.width - leftWidth
                
                if rightWidth >= tagLabel.width {  // 按钮显示在当前行
                    tagLabel.y = previousLabel.y
                    tagLabel.x = leftWidth
                }
                else {
                    tagLabel.x = 0
                    tagLabel.y = previousLabel.frame.maxY + ADTagMargin
                }
            }
        }

        //最后一个标签
        let lastTagLabel = self.tagLabels.last!
        let leftWidth = lastTagLabel.frame.maxX + ADTagMargin
        
        //更新textField的frame
        if self.topView.width - leftWidth >= self.addButton.width {
            self.addButton.x = leftWidth
            self.addButton.y = lastTagLabel.y
        }
        else {
            self.addButton.x = 0
            self.addButton.y = lastTagLabel.frame.maxY + ADTagMargin
        }
    }
}
