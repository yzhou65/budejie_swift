//
//  ADRecommendViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

private let url = "https://api.budejie.com/api/api_open.php"
private let categoryId = "category"
private let userId = "user"

class ADRecommendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var userTableView: UITableView!
    
    // 正在请求的数据字典
    private var params: NSMutableDictionary?
    

    // MARK: - 初始化设置
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置tableViews
        self.configTableView()
        
        // 设置刷新
        self.configRefresh()
        
        // 加载categories
        self.loadCategories()
    }
    
    private func configTableView() {
        //使用了xib来定制cell，所以要对相应的tableView进行cell的注册
        //现在有2个tableView公用一个控制器
        
        self.categoryTableView.register(UINib(nibName: String(describing: ADRecommendCategoryCell.self), bundle: nil), forCellReuseIdentifier: categoryId)
        self.userTableView.register(UINib(nibName: String(describing: ADRecommendUserCell.self), bundle: nil), forCellReuseIdentifier: userId)
        
        //设置inset
        self.automaticallyAdjustsScrollViewInsets = false
        self.categoryTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.userTableView.contentInset = self.categoryTableView.contentInset;
        self.userTableView.rowHeight = 70;  // row的高度默认为44
        
        //标题
        self.title = "推荐关注"
        
        //背景色
        self.view.backgroundColor = adGlobalColor()
    }
    
    // MARK: - 设置刷新控件
    private func configRefresh() {
        self.userTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewUsers))
        self.userTableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreUsers))
    }
    
    // MARK: - 加载Categories 和 Users
    private func loadCategories() {
        // 显示指示器
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        let params = ["a": "category", "c": "subscribe"]
        self.networkManager.get("", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response) in
            // 隐藏指示器
            SVProgressHUD.dismiss()
            
            let dict = (response as! [String: Any])["list"] as! [[String: Any]]
            self.categories = ADRecommendCategory.objectsWithDictionaries(dictArr: dict) as! [ADRecommendCategory]
            self.categories = ADRecommendCategory.objectsWithDictionaries(dictArr: dict, replacedKeyNames: nil) as! [ADRecommendCategory]
            
            // 刷新列表
            self.categoryTableView.reloadData()
            
            // 开始刷新列表
            self.userTableView.mj_header.beginRefreshing()
            
            //默认选中首行
            self.categoryTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.top)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error)
            // 隐藏指示器
//            SVProgressHUD.dismiss()
            // 这个方法自动隐藏指示器
            SVProgressHUD.showError(withStatus: "加载推荐信息失败!")
        }
    }
    
    
    /**
     * 一般是加载新数据只需要将包含第一条数据id等的params发给服务器, 然后返回比这个id大的数据,再把这些比此id大的数据insert到数组之前. 但是百思不得姐服务器不支持
     * 所以此处每次加载新数据会加载所有数据
     */
    @objc private func loadNewUsers() {
        // 当前选定的category
        let sc = self.selectedCategory()
        
        //设置当前页码为1
        sc.currentPage = 1

        //发送请求给服务器，加载右侧的数据. params得用NSMutableDictionary,否则仅仅是[hashable: Any]无法判断self.params = params
        let params = NSMutableDictionary()
        params["a"] = "list"
        params["c"] = "subscribe"
        params["category_id"] = sc.id!
        params["page"] = sc.currentPage
        self.params = params
        
        
        //发送请求给服务器，加载右侧的数据
        self.networkManager.get(url, parameters: params, progress: nil, success: { (_, response) in
            
            //字典数组转为模型数组
            let dict = response as! [String: Any]
//            let users = ADRecommendUser.objectsWithDictionaries(dictArr: dict["list"] as! [[String: Any]]) as! [ADRecommendUser]
            let users = ADRecommendUser.objectsWithDictionaries(dictArr: dict["list"] as! [[String: Any]], replacedKeyNames: nil) as! [ADRecommendUser]
            
            //清除以前的所有旧数据. 否则每次下拉刷新就会重复添加数据到users里
            sc.users.removeAll()
            
            //添加到当前类别对应的用户数组中
            sc.users.append(contentsOf: users)
            
            //保存总数
            sc.total = dict["total"]! as! Int
            
            //如果上一次请求和当前请求不一样(即不是最后一次请求)，就要停止上一次的请求(上一次请求已经不需要了), 只执行当前请求
            // 返回的数据还是可以append, 但是刷新表格的耗时操作就不应该继续
            if self.params != params { return }
            
            // 刷新右边表格
            self.userTableView.reloadData()
            
            // 结束刷新
            self.userTableView.mj_header.endRefreshing()
            
            //让底部控件结束刷新
            self.checkFooterState()
            
        }) { (_, error) in
            //如果上一次请求和当前请求不一样，就不要继续上一次的请求
            if self.params != params { return }
            
            //提醒错误
            SVProgressHUD.showError(withStatus: "加载用户数据失败")
            
            //结束刷新
            self.userTableView.mj_header.endRefreshing()
        }
    }
    
    
    @objc private func loadMoreUsers() {
        // 当前选定的category
        let sc = self.selectedCategory()
        
        //发送请求给服务器，加载右侧的数据. params得用NSMutableDictionary,否则仅仅是[hashable: Any]无法判断self.params = params
        let params = NSMutableDictionary()
        params["a"] = "list"
        params["c"] = "subscribe"
        params["category_id"] = sc.id!
        sc.currentPage += 1
        params["page"] = sc.currentPage
        
        
        //发送请求给服务器，加载更多右侧的数据
        self.networkManager.get(url, parameters: params, progress: nil, success: { (_, response) in
            
            //字典数组转为模型数组
            let dict = response as! [String: Any]
//            let users = ADRecommendUser.objectsWithDictionaries(dictArr: dict["list"] as! [[String: Any]]) as! [ADRecommendUser]
            let users = ADRecommendUser.objectsWithDictionaries(dictArr: dict["list"] as! [[String: Any]], replacedKeyNames: nil) as! [ADRecommendUser]
            
            // 直接append到当前类别对应的用户数组中
            sc.users.append(contentsOf: users)
            
            // 刷新右边表格
            self.userTableView.reloadData()
            
            //让底部控件结束刷新
            self.checkFooterState()
            
        }) { (_, error) in
            //提醒错误
            SVProgressHUD.showError(withStatus: "加载用户数据失败")
            
            //结束刷新
            self.userTableView.mj_footer.endRefreshing()
        }
    }
    
    
    private func checkFooterState() {
        // 当前选定的category
        let sc = self.selectedCategory()
        
        //每次刷新右边数据时，都控制footer显示或隐藏
        self.userTableView.mj_footer.isHidden = (sc.users.count == 0)
        
        // 当某个category里所有的user都加载完毕, 就让底部控件告知全部数据已加载
        if sc.users.count == sc.total {
            self.userTableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            self.userTableView.mj_footer.endRefreshing()
        }
    }
    
    
    // MARK: - UITableViewDataSource数据源
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // categoryTable
        if tableView == self.categoryTableView {
            return self.categories.count
        }
        
        // userTable
        // 接收到返回的请求数据之前, 左边categoryTable也是什么也没有, self.categories是空的, 那么categoryTableView.indexPathForSelectedRow也 == nil
        guard let indexPath = self.categoryTableView.indexPathForSelectedRow else {
            return 0
        }
        return self.categories[indexPath.row].users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.categoryTableView {    // 左边category的表
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryId) as! ADRecommendCategoryCell
            cell.category = self.categories[indexPath.row]
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: userId) as! ADRecommendUserCell
        cell.user = self.selectedCategory().users[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate代理
    // 只监听左边category列表的点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //要避免网络延迟，导致加载某个category时，点击另一个category会显示前一个category数据的错误，
        // 结束刷新
        self.userTableView.mj_header.endRefreshing()
        self.userTableView.mj_footer.endRefreshing()
        
        let sc = self.categories[indexPath.row]
        if sc.users.count > 0 {
            // 不需要再次发送网络请求, 直接显示曾经下载过的数据
            self.userTableView.reloadData()
        }
        else {
            //赶紧刷新表格，目的是：马上显示当前category的用户数据。不让使用者因为网络延迟而看见上一个category的残留数据
            self.userTableView.reloadData()
            
            //进入下拉刷新状态. 此时会调用loadNewUsers
            self.userTableView.mj_header.beginRefreshing()
        }
    }
    
    
    // MARK: - 返回选定的category
    private func selectedCategory() -> ADRecommendCategory {
        let indexPath = self.categoryTableView.indexPathForSelectedRow
        return self.categories[indexPath!.row]
    }
    
    // MARK: - 懒加载
    private lazy var networkManager = ADNetworkManager.shared()
    private lazy var categories = [ADRecommendCategory]()
    private lazy var users = [ADRecommendUser]()
    
    
    // MARK: - 控制器销毁
    /**
     加载数据但response还没返回的期间，用户可能点击“返回”。此时就要在销毁控制器的时候，停止AFTHTTPSessionManager的所有操作。
     */
    deinit {
        self.networkManager.operationQueue.cancelAllOperations() // 停止所有操作
    }
}
