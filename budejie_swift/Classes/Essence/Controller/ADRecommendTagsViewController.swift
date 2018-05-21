//
//  ADRecommendTagsViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/3/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SVProgressHUD

//private let url = "https://api.budejie.com/api/api_open.php"
private let id = "tag"

class ADRecommendTagsViewController: UITableViewController {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 当前控制器的tableView的一些设置
        self.configTableView()
        
        // 发请求加载推荐标签
        self.loadTags()
    }
    
    // MARK: - tableView初始设置
    private func configTableView() {
        self.title = "推荐标签"
        
        self.tableView.register(UINib(nibName: String(describing: ADRecommendTagCell.self), bundle: nil), forCellReuseIdentifier: id)
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = adGlobalColor()
    }
    
    // MARK: - 发请求加载标签
    private func loadTags() {
        // HUD
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let params = ["a": "tag_recommend", "action": "sub", "c": "topic"]
        self.networkManager.get(budejie_url, parameters: params, progress: nil, success: { (_, response) in
            SVProgressHUD.dismiss()
            
//            self.adPrint(response)
            let dict = response as! [[String: Any]]
            self.recommendTags = ADRecommendTag.objectsWithDictionaries(dictArr: dict) as! [ADRecommendTag]
            self.recommendTags = ADRecommendTag.objectsWithDictionaries(dictArr: dict, replacedKeyNames: nil) as! [ADRecommendTag]
            
            // 刷新表格
            self.tableView.reloadData()
            
        }) { (_, error) in
            SVProgressHUD.showError(withStatus: "加载推荐标签失败")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.recommendTags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! ADRecommendTagCell
        cell.recommendTag = self.recommendTags[indexPath.row]
        return cell
    }

    // MARK: - 懒加载
    private lazy var networkManager = ADNetworkManager.shared()
    private lazy var recommendTags = [ADRecommendTag]()
}
