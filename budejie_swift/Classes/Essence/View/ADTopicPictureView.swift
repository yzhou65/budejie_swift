//
//  ADTopicPictureView.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/5/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SDWebImage

class ADTopicPictureView: UIView, UIViewControllerPreviewingDelegate {
    // MARK: - 子控件, 成员变量
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var seeBigButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: ADProgressView!

    var topic: ADTopic? {
        didSet {
            //避免网速慢，导致cell的循环利用出错.要在每次进入的时候立刻显示最新的图片下载进度。防止因为网速慢，导致显示的是其他图片的下载进度
            self.progressView.setProgress(topic!.pictureProgress, animated: false)
            
            /**
             在不知道图片扩展名的情况下，如何知道图片的真实类型？
             取出图片数据的第一个字节，就可以判断出图片的真实类型
             */
            //设置图片
            self.imageView.sd_setImage(with: URL(string: topic!.large_image!)!, placeholderImage: nil, options: SDWebImageOptions.init(rawValue: 0), progress: { (receivedSize: Int, expectedSize: Int) in
                self.progressView.isHidden = false
                
                // 计算进度
                let progress = 1.0 * CGFloat(receivedSize) / CGFloat(expectedSize)
                self.topic!.pictureProgress = progress
                
                // 显示进度
                self.progressView.setProgress(progress, animated: false)
                
            }) { (image: UIImage?, _, _, _) in
                self.progressView.isHidden = true
                if !self.topic!.isBigPicture {
                    return
                }
                
                // 开启图形上下文
                UIGraphicsBeginImageContext(self.topic!.pictureFrame!.size)
                
                
                // 将下载完成的image对象绘制到图形上下文
                let width = self.topic!.pictureFrame!.size.width
                let height = width * image!.height / image!.width
                image!.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                
                // 获得新图片
                self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()!
                
                // 结束上下文
                UIGraphicsEndImageContext()
            }
            
            //判断是否为gif
            let ext = (topic!.large_image! as NSString).pathExtension
            self.gifView.isHidden = (ext.lowercased() != "gif")
            
            //判断是否显示“点击查看全图”
            self.seeBigButton.isHidden = !topic!.isBigPicture
        }
    }
    
    var previewBlock: (()->())?
    
    // MARK: - 初始化和设置
    class func pictureView() -> ADTopicPictureView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.last as! ADTopicPictureView
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.autoresizingMask = UIViewAutoresizing.init(rawValue: 0) //这个很重要。如果不设置autoresizing，就会导致picture的尺寸与下面设置的不一样（可能会超出范围）
        
        // 手势
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicture)))
    }
    
    // MARK: - 手势响应
    @objc private func showPicture() {
        let showPictureVC = ADShowPictureViewController(topic: self.topic)
//        showPictureVC.topic = self.topic
        
        //当前类是个UIView，没有presentViewController方法，所以要拿到keyWindow的根控制器
        UIApplication.shared.keyWindow!.rootViewController?.present(showPictureVC, animated: true, completion: nil)
    }
    
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let detailVC = ADDetailViewController(nibName: String(describing: ADDetailViewController.self), bundle: nil)
        detailVC.photo = self.imageView.image
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300.0)
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = self.frame
        } else {
            // Fallback on earlier versions
        }
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
    
}
