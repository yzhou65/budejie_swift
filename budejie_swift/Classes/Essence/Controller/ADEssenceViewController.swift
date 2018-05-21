//
//  ADEssenceViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/25/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class ADEssenceViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - 成员变量
    
    // 当前被选中的button
    private var selectedBtn: UIButton?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏的内容
        self.configNav()
        
        // 添加子控制器
        self.configChildViewControllers()
        
        // 设置标题滑动区域
        self.configTitlesView()
        
        // 设置可左右滑动的scrollView内容
        self.configContentsView()
    }
    
    // MARK: - 初始化设置
    // 设置导航栏内容
    private func configNav() {
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "MainTitle"))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: "MainTagSubIcon", highlightedImage: "MainTagSubIconClick", target: self, action: #selector(tagClick))
        
        //设置背景色. 不要在ADTabBarController里设置, 否则导致控制器提前创建, 而非点击使用时才创建
        self.view.backgroundColor = adGlobalColor()
    }
    
    /**
     初始化子控制器
     */
    private func configChildViewControllers() {
        let all = ADTopicViewController(title: "全部内容", type: ADTopicType.all)
        self.addChildViewController(all)
        
        let video = ADTopicViewController(title: "视频", type: ADTopicType.video)
        self.addChildViewController(video)
        
        let voice = ADTopicViewController(title: "声音", type: ADTopicType.voice)
        self.addChildViewController(voice)
        
        let picture = ADTopicViewController(title: "图片", type: ADTopicType.picture)
        self.addChildViewController(picture)
        
        let word = ADTopicViewController(title: "段子", type: ADTopicType.word)
        self.addChildViewController(word)
    }
    
    // 设置标题滑动区域
    private func configTitlesView() {
  
        //标签栏内部子标签
        let count = self.childViewControllers.count
        let width = self.titlesView.width / CGFloat(count)
        let height = self.titlesView.height     // 每个子标签高度
        for i in 0..<count {
            let btn = UIButton(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height))
            btn.tag = i
            
            // 根据子控制器来设置这些button
            let vc = self.childViewControllers[i]
            btn.setTitle(vc.title, for: UIControlState.normal)
            btn.setTitleColor(UIColor.gray, for: UIControlState.normal)
            btn.setTitleColor(UIColor.red, for: UIControlState.disabled)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//            btn.addTarget(self, action: #selector(titleTapped(_:)), for: UIControlEvents.touchUpInside)
            
            btn.reactive.controlEvents(UIControlEvents.touchUpInside).observeValues({ (_) in
                self.titleTapped(btn)
            })
            
            self.titlesView.addSubview(btn)
            
            // 默认点击了第一个按钮(开始的时候默认点击不带任何动画，所以不调用titleTapped, 直接手动改变width和redIndicator)
            if i == 0 {
                btn.isEnabled = false
                self.selectedBtn = btn
                
                // 让按钮内部的label根据文字内容来计算尺寸
                btn.titleLabel!.sizeToFit()
                // 下面这两句不能换位置. 必须先有宽度再设置centerX, 否则位置出错
                self.redIndicator.width = btn.titleLabel!.width
                self.redIndicator.centerX = btn.centerX
            }
        }
        
        // 加了所有按钮后, 最后才在titlesView上添加红色指示器, 这样方便下面滑动动画中通过self.subviews[i]取得之前的按钮,而不会被红色指示器干扰
        self.titlesView.addSubview(self.redIndicator)
    }
    
    
    private func configContentsView() {
        //不要自动调整inset, 否则系统会自动给contentsView上下分配一个insets
        self.automaticallyAdjustsScrollViewInsets = false

        // 默认显示第一个控制器view
        self.scrollViewDidEndScrollingAnimation(self.contentsView)
    }
    
    // MARK: - 按钮监听
    @objc private func titleTapped(_ btn: UIButton) {
        // 修改按钮动画
        self.selectedBtn?.isEnabled = true
        btn.isEnabled = false
        self.selectedBtn = btn
        
        // redIndicator滑动动画
        UIView.animate(withDuration: 0.25) {
            // 下面这两句不能换位置. 必须先有宽度再设置centerX, 否则位置出错
            self.redIndicator.width = btn.titleLabel!.width
            self.redIndicator.centerX = btn.centerX
        }
        
        // 滑动中间的文字,video,voice等内容的scrollView
        let offset = CGPoint(x: CGFloat(btn.tag) * self.contentsView.width, y: 0)
        self.contentsView.setContentOffset(offset, animated: true)
    }
    
    @objc private func tagClick() {
        self.navigationController?.pushViewController(ADRecommendTagsViewController(), animated: true)
    }
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let width = scrollView.width
        let height = scrollView.height
        let offsetX = scrollView.contentOffset.x
        
        //当前的索引
        let index:Int = Int(offsetX / width)
        
        // 取出子控制器添加其view
        let willShowVC = self.childViewControllers[index]
        if willShowVC.isViewLoaded {
            return
        }
        
        //设置控制器view的height = 整个屏幕的高度（默认是屏幕高度－20）
        //修改控制器view的默认y值 = 0（默认值为20）
        willShowVC.view.frame = CGRect(x: offsetX, y: 0, width: width, height: height)
//        print(willShowVC.view.frame)
        scrollView.addSubview(willShowVC.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrollingAnimation(scrollView)
        
        // 点击按钮
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        self.titleTapped(self.titlesView.subviews[index] as! UIButton)
    }
    
    
    // MARK: - 懒加载
    // 标签栏
    private lazy var titlesView: UIScrollView = {
        let tv = UIScrollView(frame: CGRect(x: 0, y: ADTitlesViewY, width: self.view.width, height: ADTitlesViewH))
        tv.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        tv.tag = -1

        //        titlesView.alpha = 0.5; //这样做不好，因为会导致内部子控件也半透明。所以应该直接如上设置背景色的alpha
        
        self.view.addSubview(tv)
        return tv
    }()
    
    
    // 每个子标签底部的红色指示器
    private lazy var redIndicator: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.red
        iv.height = 2
        iv.y = self.titlesView.height - iv.height
        return iv
    }()
    
    
    // 中间的可左右滑动的文字,video,voice等内容scrollView
    private lazy var contentsView: UIScrollView = {
        // 为了使内容有穿透效果, 那么cv的尺寸应该和self.view一样
        let cv: UIScrollView = UIScrollView(frame: self.view.bounds)
        self.view.insertSubview(cv, at: 0)  // addSubview会遮住标题栏
//        print(cv.frame)
//        cv.backgroundColor = UIColor.blue
        
        //contentView滚动完成后需要加载内容，所以要使当前控制器成为其代理
        cv.delegate = self
        
        // 分页效果
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        // 设置滑动范围
        cv.contentSize = CGSize(width: CGFloat(self.childViewControllers.count) * cv.width, height: 0)
        //注意这个contentView是水平滚动的。上下滚动的，是每个tableViewController内部的tableView滚动
        
        // 以下代码无法实现穿透效果
        //    cv.width = self.view.width;
        //    cv.y = 99;
//            cv.height = self.view.height - cv.y - self.tabBarController!.tabBar.height
        
        return cv
    }()

}
