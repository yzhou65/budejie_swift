//
//  ADCommentViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/6/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

private let id = "ADCommentCell"
private let headerId = "header"

class ADCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - 子控件, 成员变量
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textField: UITextField!
    
//    /** 最热评论 */
//    private var hotComments: [ADComment]?
    
    /** 保存帖子的top_cmt */
//    private var saved_top_cmt: ADComment?
    private var saved_top_cmt: Comment?
    
    /** 当前的页码 */
    private var page: Int = 0
    
    /** 上一次选中的行号 */
    private var selected: IndexPath?
    
//    var topic: ADTopic?
    var topic = Topic()
    

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configTableView()
        self.configHeader()
        self.configRefresh()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        //恢复帖子的top_cmt
        if self.topic.topCmt != nil {
            self.topic.topCmt = self.saved_top_cmt
//            self.topic!.setValue(0, forKey: "cellHeight")   // 归零cellHeight以便deinit后回到外面重新计算
            self.topic.cellHeight = 0
        }

        //取消所有任务
//        self.networkManager.invalidateSessionCancelingTasks(true)
    }
    
    // MARK: - 初始设置
    private func configTableView() {
        self.title = "评论"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: "comment_nav_item_share_icon", highlightedImage: "comment_nav_item_share_icon_click", target: nil, action: nil)
        
        // cell的高度设置(ios8以后可以先给cell估计高度，然后让其自动dimension)
        // topicCell无法自动计算高度是因为其内部是否有text,voice,video不确定,不像此处的commentCell虽然高度不确定,但是内部的控件内容已确定
        self.tableView.estimatedRowHeight = 44 //自动尺寸之前必须设置估计高度
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //背景色
        self.tableView.backgroundColor = adGlobalColor()
        
        //注册自定义cell
//        self.tableView.register(UINib(nibName: String(describing: ADCommentCell.self), bundle: nil), forCellReuseIdentifier: id)
//        self.tableView.register(ADCommentHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        self.tableView.ad_registerCell(with: ADCommentCell.self)
        self.tableView.register(ADCommentHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        //去掉分隔线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //内边距
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ADTopicCellMargin, right: 0)
        
        // 注册通知. 此处的textField不能被作为inputAccessoryView, 因为一进来这个ADCommentViewController, 这个textField就长期固定在下面, 不会随键盘消失
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // 添加长按手势
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(_:)))
        self.tableView.addGestureRecognizer(lpgr)
    }
    
    private func configHeader() {
        // 设置header
        self.tableView.tableHeaderView = self.originalTopic
    }
    
    private func configRefresh() {
        // header
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewComments))
        self.tableView.mj_header.beginRefreshing()
        
        // footer
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreComments))
        self.tableView.mj_footer.isHidden = true
    }
    
    
    // MARK: - 通知: 键盘相关
    @objc private func keyboardWillChangeFrame(_ notify: Notification) {
        self.textField.text = ""
        // 键盘显示／隐藏完毕的frame
        let frame: CGRect = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        // 修改底部约束
        self.bottomSpaceConstraint.constant = ADScreenH - frame.origin.y
        
        //动画
        let duration = notify.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 刷新相关
    @objc private func loadNewComments() {
        //结束之前的所有请求. 避免上拉和下拉刷新同时进行造成混乱
        self.tableView.mj_header.endRefreshing()
//        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
        
        //参数
        let params = ["a": "dataList", "c": "comment", "data_id": self.topic.id, "hot": "1"]
        self.networkManager.get(budejie_url, parameters: params, progress: nil, success: { (_, response) in
//            print(response!)
            // 如果没有评论数据就返回
            if !((response as AnyObject).isKind(of: NSDictionary.self)) {
                self.tableView.mj_header.endRefreshing()
                return
            }
            
            guard response != nil else { return }
            // 最热评论
//            let dict = response as! [String: Any]
//            let hotComments = ADComment.objectsWithDictionaries(dictArr: dict["hot"] as! [[String : Any]], replacedKeyNames: nil) as! [ADComment]
//            self.hotComments = hotComments
//
//            // 最新评论
//            let latestComments = ADComment.objectsWithDictionaries(dictArr: dict["data"] as! [[String : Any]], replacedKeyNames: nil) as! [ADComment]
//            self.latestComments = latestComments
            
            let json = JSON(response!)
            if let datas = json["hot"].arrayObject {
                var hotComments = [Comment]()
                
                hotComments = datas.compactMap({ Comment.deserialize(from: $0 as? Dictionary)})
                self.hotComments = hotComments
            }
            if let latestDatas = json["data"].arrayObject {
                var lastestComments = [Comment]()
                lastestComments = latestDatas.compactMap({ Comment.deserialize(from: $0 as? Dictionary)})
                self.latestComments = lastestComments
            } else {
                return
            }
            
            // 页码
            self.page = 1
            
            // 刷新UI
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
            // 控制footer状态
//            print(dict["total"]!)
//            let total = (dict["total"] as! NSString).intValue // 错误
//            let total = dict["total"]! as! Int    // 错误
            let total = "\(json["total"])"
//            print(self.latestComments.count)
            if self.latestComments.count >= Int(total)! {
                self.tableView.mj_footer.isHidden = true
            }
            
        }) { (_, _) in
            //结束刷新
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    @objc private func loadMoreComments() {
        //结束之前的所有请求
        self.tableView.mj_header.endRefreshing()
        
//        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//        
        // 页码
        let page = self.page + 1
        
        //参数
        let params = ["a": "dataList", "c": "comment", "data_id": self.topic.id, "page": page, "lastcid": self.latestComments.last!.id] as [String : Any]
        
        self.networkManager.get(budejie_url, parameters: params, progress: nil, success: { (_, response) in
//            print(response)
            if !((response as AnyObject).isKind(of: NSDictionary.self)) {
                self.tableView.mj_footer.isHidden = true
                return
            }
            
            // 最新评论
//            let dict = response as! [String: Any]
//            let moreComments = ADComment.objectsWithDictionaries(dictArr: dict["data"] as! [[String : Any]], replacedKeyNames: nil) as! [ADComment]
//            for (c, d) in zip(moreComments, dict["data"] as! [[String : Any]]) {
//                c.user = ADUser.object(with: d["user"] as! [String: Any], replacedKeyNames: nil)
//            }
//            self.latestComments.append(contentsOf: moreComments)
            
            guard response != nil else { return }
            let json = JSON(response!)
            if let latestDatas = json["data"].arrayObject {
                let lc = latestDatas.compactMap({ Comment.deserialize(from: $0 as? Dictionary)})
                self.latestComments += lc
            }
            
            
            // 页码
            self.page = page
            
            // 刷新UI
            self.tableView.reloadData()
            
            // 控制footer状态
//            let total = dict["total"]! as! Int    // 错误
            let total = "\(json["total"])"
//            print(self.latestComments.count)
            if self.latestComments.count >= Int(total)! {
                self.tableView.mj_footer.isHidden = true
            } else {
                self.tableView.mj_footer.endRefreshing()
            }
            
        }) { (_, _) in
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        let hotCount = self.hotComments
        let latestCount = self.latestComments
        if hotCount.count > 0 {
            return 2    //有最热评论和最新评论, 2组
        }
        if latestCount.count > 0 {
            return 1    // 只有最新评论1组
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let hotCount = self.hotComments.count
        let latestCount = self.latestComments.count
        
        //隐藏尾部控件
        tableView.mj_footer.isHidden = (latestCount == 0)
        
        if section == 0 {
            return hotCount > 0 ? hotCount : latestCount
        }
        
        //非第0组
        return latestCount;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! ADCommentCell
        let cell = tableView.ad_dequeueReusableCell(indexPath: indexPath) as ADCommentCell
        cell.comment = self.getComment(in: indexPath)
        return cell
    }
    
    // 返回指定section里的comments
//    private func getComments(in section: Int) -> [ADComment] {
//        if section == 0 {
//            return self.hotComments.count > 0 ? self.hotComments : self.latestComments
//        }
//        return self.latestComments
//    }
    private func getComments(in section: Int) -> [Comment] {
        if section == 0 {
            return self.hotComments.count > 0 ? self.hotComments : self.latestComments
        }
        return self.latestComments
    }
    
//    private func getComment(in indexPath: IndexPath) -> ADComment {
//        return self.getComments(in: indexPath.section)[indexPath.row]
//    }
    private func getComment(in indexPath: IndexPath) -> Comment {
        return self.getComments(in: indexPath.section)[indexPath.row]
    }
    
    // MARK: - UITableViewDelegate
    /**
     * 这个方法如果不调用, 下面的viewForHeaderInSection就不会调用
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ADTopicCellTopCmtTitleH + 5
    }
    
    /**
     用这个方法的好处是，最热评论或最新评论的排头header不会因为滚动到下面而消失(table滚动到下面时,也能停留在屏幕上方)
     注意: 此方法能正常工作的前提是, 实现heightForHeaderInSection方法. 并且不要实现titleForHeaderInSection方法
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //先从缓存池中找header. 也可以使用注册
//        let header = ADCommentHeaderView.headerView(with: tableView)
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ADCommentHeaderView
        //设置label的数据
        let hotCount = self.hotComments.count
        if section == 0 {
            header.title = hotCount > 0 ? "最热评论" : "最新评论"
        } else {
            header.title = "最新评论"
        }
        return header
    }
    
    
    /**
     在此方法中写退出键盘的代码，比在didScroll方法中写更好，因为didScroll调用太频繁，且退出键盘只需要一次
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // UIMenuController控制单元格上的复制,粘贴,转发等菜单按钮
        let cell = tableView.cellForRow(at: indexPath) as! ADCommentCell
        
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        self.textField.becomeFirstResponder()
        self.textField.text = "@ \(cell.comment.user.username): "
    }
    
    // MARK: - 长按, MenuItem相关响应
    @objc private func cellLongPressed(_ lpgr: UILongPressGestureRecognizer) {
        let point = lpgr.location(in: self.tableView)
        let menu = UIMenuController.shared
        if let indexPath = self.tableView.indexPathForRow(at: point) {
            if lpgr.state == UIGestureRecognizerState.began {
                if menu.isMenuVisible {
                    menu.setMenuVisible(false, animated: true)
                }
            }
            else if lpgr.state == UIGestureRecognizerState.ended {
                // 被点击的cell
                let cell = tableView.cellForRow(at: indexPath) as! ADCommentCell
                
                cell.becomeFirstResponder()

                // 显示MenuController
                let ding = UIMenuItem(title: "顶", action: #selector(ding(_:)))
                let reply = UIMenuItem(title: "回复", action: #selector(reply(_:)))
                let report = UIMenuItem(title: "举报", action: #selector(report(_:)))
                menu.menuItems = [ding, reply, report]
                menu.setTargetRect(CGRect(x: 0, y: cell.height * 0.5, width: cell.width, height: cell.height * 0.5), in: cell)  // setTargetRect是给menu设置一个附着的矩形框(cell的下半部分),而不是给menu设置显现位置
                menu.setMenuVisible(true, animated: true)
            }
        }
    }
    
    @objc private func ding(_ menuController: UIMenuController) {
        print(#function + ", " + "\(self.getComment(in: self.tableView.indexPathForSelectedRow!).content)")
    }
    
    @objc private func reply(_ menuController: UIMenuController) {
        print(#function + ", " + "\(self.getComment(in: self.tableView.indexPathForSelectedRow!).content)")
    }
    
    @objc private func report(_ menuController: UIMenuController) {
        print(#function + ", " + "\(self.getComment(in: self.tableView.indexPathForSelectedRow!).content)")
    }
    
    // MARK: - 懒加载
    private lazy var networkManager = ADNetworkManager.shared()
    
    /** 最新评论: 不要以new开头命名变量，系统会认为是new方法 */
//    private lazy var latestComments = [ADComment]()
    private lazy var latestComments = [Comment]()
    /** 最热评论 */
//    private var hotComments = [ADComment]()
    private var hotComments = [Comment]()
    
    /** 放置被评论的原帖 */
    private lazy var originalTopic: UIView = {
        // 创建header
        let header = UIView()
        
        // 清空top_cmt, 因为在当前控制器中, 被评论的原帖内不显示最热评论(最热评论显示在tableView开头)
//        if self.topic!.topComment != nil {
//            self.saved_top_cmt = self.topic!.topComment // 先把最热评论存起来再清空. deinit的时候要恢复
//            self.topic!.topComment = nil
//            self.topic!.setValue(0, forKey: "cellHeight")
//        }
        if self.topic.topCmt != nil {
            self.saved_top_cmt = self.topic.topCmt! // 先把最热评论存起来再清空. deinit的时候要恢复
            self.topic.topCmt = nil
//            self.topic.setValue(0, forKey: "cellHeight")
            self.topic.cellHeight = 0
        }
        
        //添加cell到这个header上面
        let cell = ADTopicCell.cell()
        cell.topic = self.topic
        cell.frame = CGRect(origin: header.bounds.origin, size: CGSize(width: ADScreenW, height: self.topic.topicHeight()))   // 此处重新计算了topicHeight, 因为上面清空了top_cmt并且归零了cellHeight
        header.addSubview(cell)
        
        //header高度
        header.height = self.topic.topicHeight() + ADTopicCellMargin
//        print("header.frame: \(header.frame), cell.frame: \(cell.frame)")
        return header
    }()
}
