//
//  ADPublishViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 2/26/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import pop

// 数据
private let images = ["publish-video", "publish-picture", "publish-text", "publish-audio", "publish-review", "publish-offline"]
private let titles = ["发视频", "发图片", "发段子", "发声音", "审帖", "离线下载"]
private let maxCols = 3     // 所有按钮显示为maxCols列

// 弹簧相关
private let ADAnimationDelay: CGFloat = 0.1
private let ADSpringFactor: CGFloat = 10

class ADPublishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 让控制器的view不能被点击
        self.view.isUserInteractionEnabled = false
        
        // 中间的6个按钮
        let buttonW: CGFloat = 72
        let buttonH: CGFloat = buttonW + 30
        let baseY: CGFloat = (ADScreenH - 2 * buttonH) * 0.5
        let baseX: CGFloat = 20
        let buttonMargin = (ADScreenW - 2 * baseX - CGFloat(maxCols) * buttonW) / CGFloat(maxCols - 1)
        
        for i in 0..<images.count {
            let button = ADVerticalButton()
            self.view.addSubview(button)
            button.tag = i;
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControlEvents.touchUpInside)
            
            // 设置内容
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitle(titles[i], for: UIControlState.normal)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setImage(UIImage(named: images[i]), for: UIControlState.normal)
            
            // 计算坐标
            let row = i / maxCols
            let col = i % maxCols
            let buttonX = baseX + CGFloat(col) * (buttonW + buttonMargin)
            let buttonEndY = baseY + CGFloat(row) * buttonH
            let buttonBeginY = buttonEndY - ADScreenH
            
            // 按钮动画. POPAnimation与Core Animation的区别是: POPAnimation会实际实时修改控件属性尺寸等, CoreAnimation不会
            let anim = POPSpringAnimation(propertyNamed: kPOPViewFrame)!
            anim.fromValue = CGRect(x: buttonX, y: buttonBeginY, width: buttonW, height: buttonH)
            anim.toValue = CGRect(x: buttonX, y: buttonEndY, width: buttonW, height: buttonH)
            anim.springBounciness = ADSpringFactor
            anim.springSpeed = ADSpringFactor
            anim.beginTime = CACurrentMediaTime() + Double(ADAnimationDelay) * Double(i)
            button.pop_add(anim, forKey: nil)
        }
        
        // 添加标语及其动画
        self.view.addSubview(self.sloganView)
    }
    
    /**
     pop和Core Animation的区别
     1.Core Animation的动画只能添加到layer上
     2.pop的动画能添加到任何对象
     3.pop的底层并非基于Core Animation, 是基于CADisplayLink
     4.Core Animation的动画仅仅是表象, 并不会真正修改对象的frame\size等值
     5.pop的动画实时修改对象的属性, 真正地修改了对象的属性
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(completed: nil)
    }
    
    
    // MARK: - 按钮监听
    @objc private func buttonTapped(_ button: ADVerticalButton) {
        self.dismiss {
            switch button.tag {
                case 0:
                    print(titles[0])
                    break
                case 1:
                    print(titles[1])
                    break
                case 2:
                    let nav = ADNavigationController(rootViewController: ADPostWordViewController())
                    
                    // 这里不能使用self来弹出其他控制器, 因为self执行了dismiss操作
                    UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
                    break
                
                case 3:
                    print(titles[3])
                    break
                case 4:
                    print(titles[4])
                    break
                case 5:
                    print(titles[5])
                    break
                default:
                    break
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(completed: nil)
    }
    
    /**
     * 执行退出动画和completionBlock
     */
    private func dismiss(completed completion:(()->())?) {
        self.view.isUserInteractionEnabled = false
        
        let count = self.view.subviews.count
        let index = 1
        for i in index..<count {
            let subview = self.view.subviews[i]
            
            let anim = POPBasicAnimation(propertyNamed: kPOPViewCenter)!
            let centerEndY = subview.centerY + ADScreenH
            
            // 动画的执行节奏(一开始很慢, 后面很快)
//            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            anim.toValue = CGPoint(x: subview.centerX, y: centerEndY)
            anim.beginTime = CACurrentMediaTime() + Double(i - index) * Double(ADAnimationDelay)
            subview.pop_add(anim, forKey: nil)
            
            // 监听最后一个动画
            if i == count - 1 {
                anim.completionBlock = { (anim: POPAnimation?, finished: Bool) -> () in
                    
                    // dismiss当前控制器并执行传进来的completionBlock参数
                    self.dismiss(animated: true, completion: completion)
                }
            }
        }
    }

    
    // MARK: - 懒加载
    private lazy var sloganView: UIImageView = {
        let sv = UIImageView(image: UIImage(named: "app_slogan"))
        let centerX: CGFloat = self.ADScreenW * 0.5
        let centerEndY: CGFloat = self.ADScreenH * 0.2
        let centerBeginY: CGFloat = centerEndY - self.ADScreenH
        sv.center = CGPoint(x: centerBeginY, y: centerBeginY) // 先把sloganView的位置设置在屏幕外. 有了这句话就不会导致sloganView在刚进入界面时停留在界面左上角
        
        // 标语动画
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)!
        anim.fromValue = CGPoint(x: centerX, y: centerBeginY)
        anim.toValue = CGPoint(x: centerX, y: centerEndY)
        anim.springBounciness = ADSpringFactor
        anim.springSpeed = ADSpringFactor
        anim.beginTime = CACurrentMediaTime() + Double(images.count) * Double(ADAnimationDelay)
        anim.completionBlock = { (anim: POPAnimation?, finished: Bool) -> () in
            self.view.isUserInteractionEnabled = true
        }
        sv.pop_add(anim, forKey: nil)
        return sv
    }()

}
