//
//  ADCommentHeaderView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/8/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit

private let headerId = "header"

class ADCommentHeaderView: UITableViewHeaderFooterView {
    
    var title: String? {
        didSet {
            self.label.text = title!
        }
    }
    
    // MARK: - 构造
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.backgroundColor = adGlobalColor()
        self.contentView.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func headerView(with tableView: UITableView) -> ADCommentHeaderView {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ADCommentHeaderView
        if header == nil {
            header = ADCommentHeaderView(reuseIdentifier: headerId)
        }
        return header!
    }
    
    // MARK: - 懒加载
    /** 文字标签 */
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = self.adColor(67.0, 67.0, 67.0)
        label.width = 200
        label.x = self.ADTopicCellMargin
        label.autoresizingMask = UIViewAutoresizing.flexibleHeight
        return label
    }()
}
