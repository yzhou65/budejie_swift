//
//  ADMeViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/9/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

private let id = "me"

class ADMeViewController: UITableViewController {
    var squares = [Square]()
    // MARK: - 基础设置

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏的内容
        self.configNav()
        
        self.configTableView()
        
        self.configFooterView()
    }
    
    // 设置导航栏内容
    private func configNav() {
        //设置导航栏标题
        self.navigationItem.title = "我的"
        
        //设置导航栏右边的2个按钮
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: "mine-setting-icon", highlightedImage: "mine-setting-icon-click", target: self, action: #selector(settingClick)), UIBarButtonItem(image: "mine-moon-icon", highlightedImage: "mine-moon-icon-click", target: self, action: #selector(nightClick))]
    }
    
    private func configTableView() {
        //设置背景色, 分隔线
        self.tableView.backgroundColor = adGlobalColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //注册cell
        self.tableView.register(ADMeCell.self, forCellReuseIdentifier: id)
//        self.tableView.ad_registerCell(with: ADMeCell.self)
        
        
        //调整header和footer
//        self.tableView.sectionHeaderHeight = 0
        self.tableView.sectionFooterHeight = ADTopicCellMargin
        self.tableView.contentInset = UIEdgeInsets(top: ADTopicCellMargin, left: 0, bottom: 0, right: 0)
        
        //设置footerView
//        let footer = ADMeFooterView()
//        self.tableView.tableFooterView = footer
    }
    
    private func configFooterView() {
        //参数
        let params = ["a": "square", "c": "topic"]
        
        // HUD
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        self.networkManager.get(budejie_url, parameters: params, progress: nil, success: { (_, response) in
            
            SVProgressHUD.dismiss()
            guard response != nil else {
                SVProgressHUD.show(withStatus: "暂无数据")
                return
            }
            let json = JSON(response!)
            if let datas = json["square_list"].arrayObject {
                let squares = datas.compactMap({ Square.deserialize(from: $0 as? Dictionary) })
//                self.tableView.tableFooterView = ADMeFooterView(squares: squares)
                
                let footerView = ADMeFooterCollectionView(frame: CGRect.zero, collectionViewLayout: ADMeCollectionLayout())
                footerView.squares = squares
                self.tableView.tableFooterView = footerView
            }
            
        }) { (_, error) in
            print(error)
            SVProgressHUD.showError(withStatus: "网络加载错误")
        }
    }
    
    // MARK: - 按钮监听
    @objc private func settingClick() {
        self.navigationController?.pushViewController(ADSettingViewController(style: UITableViewStyle.grouped), animated: true)
    }
    
    @objc private func nightClick() {
        print(#function)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! ADMeCell
//        let cell = tableView.ad_dequeueReusableCell(indexPath: indexPath) as ADMeCell

        if indexPath.section == 0 {
            cell.imageView?.image = UIImage(named: "mine_icon_nearby")
            cell.textLabel?.text = "登录/注册"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "离线下载"
        }
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    // MARK: - UICollectionView data source

    
    // MARK: - 懒加载
    private lazy var networkManager = ADNetworkManager.shared()
}
