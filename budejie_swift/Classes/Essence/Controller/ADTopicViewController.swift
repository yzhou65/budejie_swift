//
//  ADTopicViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/4/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import SwiftyJSON

private let id = "topic"

class ADTopicViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    // MARK: - 构造方法
    init() {
        super.init(style: UITableViewStyle.plain)
    }

    init(title: String, type: ADTopicType) {
        super.init(style: UITableViewStyle.plain)
        self.title = title
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 成员变量
    /** 帖子类型(交给子类去实现) */
    var type: ADTopicType?
    
    
    /** 当前页码 */
    private var page: Int = 0
    
    /** 当加载下一页数据时，需要的参数 */
    private var maxtime: String?

    /** 上一次的请求参数 */
    private var params: NSDictionary?
    
    /** 上次选中的控制器索引 */
    private var lastSelectedIndex = 0
    
    // MARK: - 初始化设置
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化表格
        self.configTableView()

        //添加显示正在刷新的控件
        self.configRefresh()
        
        // 加载帖子
        self.loadNewTopics()
        
        // 设置3D touch
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == .available {
                self.registerForPreviewing(with: self, sourceView: self.view)
            }
        } else {
            // Fallback on earlier versions
            print("3D touch unavailable")
        }
    }
    
    private func configTableView() {
        //给tableView设置一定内边距达到穿透效果
        let top: CGFloat = ADTitlesViewH + ADTopicCellMargin
        let bottom = self.tabBarController!.tabBar.height
        
        self.tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor.clear
//        self.tableView.estimatedRowHeight = 250
        
        // 注册cell
//        self.tableView.register(UINib(nibName: String(describing: ADTopicCell.self), bundle: nil), forCellReuseIdentifier: id)
        self.tableView.ad_registerCell(with: ADTopicCell.self)
        
        //监听tabBar点击的通知. 点击"精华"就刷新其内容
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarSelected), name: ADNotification.tabBarDidSelect.notificationName, object: nil)
    }
    
    // MARK: - 通知相关
    @objc private func tabBarSelected() {
        // 如果连续选中两次，刷新
        if self.lastSelectedIndex == self.tabBarController!.selectedIndex && self.view.isStayingOnKeyWindow() {
            self.tableView.mj_header.beginRefreshing()
        }
        
        //记录这一次选中的索引
        self.lastSelectedIndex = self.tabBarController!.selectedIndex
    }
    
    // MARK: - 刷新相关
    private func configRefresh() {
        // 下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewTopics))
        self.tableView.mj_header.isAutomaticallyChangeAlpha = true
        self.tableView.mj_header.beginRefreshing()
        
        // 上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreTopics))
    }
    
    @objc private func loadNewTopics() {
        // 先结束刷新控件
        self.tableView.mj_header.endRefreshing()
        
        // 发送请求
        let params = NSMutableDictionary()
        params["a"] = self.parent!.isKind(of: ADNewViewController.self) ? "newlist" : "list"
        params["c"] = "data"
        params["type"] = self.type!.rawValue
        self.params = params
        self.networkManager.get(budejie_url, parameters: params, progress: nil, success: { (_, response) in
            // 防止重复加载
            if self.params != params { return }
            
            //存储maxtime
//            print(response)
            guard response != nil else { return }
            let json = JSON(response!)
            
            print(json)
            let info = json["info"].dictionary
            let maxtime = info!["maxtime"]?.string
            self.maxtime = maxtime
            
            //字典 -> 模型
//            let topics = ADTopic.objectsWithDictionaries(dictArr: dict["list"] as! [[String: Any]], replacedKeyNames: ADTopic.replacedKeyFromPropertyName) as! [ADTopic]
//            self.topics = topics
            
            
            if let datas = json["list"].arrayObject {
                var topics = [Topic]()
                topics = datas.compactMap({ Topic.deserialize(from: $0 as? Dictionary)})
                self.topics = topics
//                self.topics = datas.compactMap({ Topic.deserialize(from: $0 as? Dictionary)})
                
                //刷新表格
                self.tableView.reloadData()
                
                //结束刷新
                self.tableView.mj_header.endRefreshing()
                
                //页码
                self.page = 0;
            }
            
        }) { (_, error) in
            SVProgressHUD.showError(withStatus: "加载数据失败")
            if self.params != params { return }
            
            //结束刷新
            self.tableView.mj_header.endRefreshing()
            
            //此处不用恢复页码。因为上面的代码是在第一次成功加载之后才给页码赋值。
        }
    }
    
    @objc private func loadMoreTopics() {
        //结束下拉
        self.tableView.mj_header.endRefreshing()
        
//        self.page += 1
        let page = self.page
        
        // 发送请求
        let params = NSMutableDictionary()
        params["a"] = self.parent!.isKind(of: ADNewViewController.self) ? "newlist" : "list"
        params["c"] = "data"
        params["type"] = self.type!.rawValue
        params["page"] = page + 1;
        params["maxtime"] = self.maxtime
        self.params = params
        
        //发送请求
        self.networkManager.get(budejie_url, parameters: params, progress: nil, success: { (_, response) in
            if self.params != params { return }
            
            // 存储maxtime
            guard response != nil else { return }
            let json = JSON(response!)
//            print(json)
            
//            let dict = response as! [String: Any]
//            self.maxtime = (dict["info"] as! [String: Any])["maxtime"] as! String?
            self.maxtime = (json["info"].dictionary)!["maxtime"]?.string
            
//            let moreTopics = ADTopic.objectsWithDictionaries(dictArr: dict["list"] as! [[String: Any]], replacedKeyNames: ADTopic.replacedKeyFromPropertyName) as! [ADTopic]
//            self.topics.append(contentsOf: moreTopics)
            
            
            if let datas = json["list"].arrayObject {
                let moreTopics = datas.compactMap({ Topic.deserialize(from: $0 as? Dictionary)})
                self.topics += moreTopics
                
                //                    completionHandler(titles)
                
                // 刷新表格
                self.tableView.reloadData()
                
                // 结束刷新
                self.tableView.mj_footer.endRefreshing()
                
                // 存储页码
                self.page = page
            }
            
            
        }) { (_, error) in
            SVProgressHUD.showError(withStatus: "加载数据失败")
            self.tableView.mj_footer.endRefreshing()
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.topics.count
        tableView.mj_footer.isHidden = (count == 0)
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! ADTopicCell
        let cell = tableView.ad_dequeueReusableCell(indexPath: indexPath) as ADTopicCell
        var topic = self.topics[indexPath.row]
        let _ = topic.topicHeight()
        
        cell.topic = topic
        return cell
    }
    
    // MARK: - UITableViewDelegate
    /**
     计算cell的高度，此方法会频繁地调用。每次加载cell的时候就会调用。所以计算cell高度最好只做一次，并且要将这个计算过程封装到YZTopic模型中。
     此方法会在cellForRowAtIndexPath之前调用。cellHeight在此处计算完后，再去上面的cellForRowAtIndexPath方法传入模型
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.topics[indexPath.row].cellHeight
        return self.topics[indexPath.row].topicHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentVC = ADCommentViewController()
        let topic = self.topics[indexPath.row]
//        print("\(topic.top_cmt)  \(topic.topComment)")
        commentVC.topic = topic
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    
    // MARK: - UIPreviewingControllerDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        print(location)
        guard let indexPath = self.tableView!.indexPathForRow(at: location) else { return nil }
        let cell = self.tableView.cellForRow(at: indexPath) as! ADTopicCell
        let point = self.tableView.convert(location, to: cell)
//        print(point)
        if cell.topic.type == ADTopicType.picture.rawValue && cell.pictureView.frame.contains(point) {
           
            let detailVC = ADDetailViewController(nibName: "ADDetailViewController", bundle: nil)
            let image = cell.pictureView.imageView.image
            detailVC.photo = image
            detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            
            if #available(iOS 9.0, *) {
                previewingContext.sourceRect = cell.pictureView.frame
            } else {
                // Fallback on earlier versions
            }
            return detailVC
        }
        else {
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.show(viewControllerToCommit, sender: self)
    }
    
    
    // MARK: - 懒加载
    /** 帖子数据 */
//    private lazy var topics: [ADTopic] = [ADTopic]()
    private lazy var topics: [Topic] = [Topic]()
    private lazy var networkManager = ADNetworkManager.shared()
    
}
