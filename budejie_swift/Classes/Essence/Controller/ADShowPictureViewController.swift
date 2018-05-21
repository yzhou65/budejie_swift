//
//  ADShowPictureViewController.swift
//  budejie_swift
//
//  Created by Yue Zhou on 3/7/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Photos
import ReactiveCocoa

class ADShowPictureViewController: UIViewController {
    // MARK: - 子控件, 成员变量
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: ADProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var topic: ADTopic?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //立刻显示当前图片下载进度, 否则会因为循环引用出问题
        self.progressView.setProgress(self.topic!.pictureProgress, animated: false)
        
        //下载图片
        self.imageView.sd_setImage(with: URL(string: self.topic!.large_image!), placeholderImage: nil, options: SDWebImageOptions.init(rawValue: 0), progress: { (received: Int, expected: Int) in
            
            self.progressView.setProgress(1.0 * CGFloat(received) / CGFloat(expected), animated: false)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        
        self.backButton.reactive.controlEvents(UIControlEvents.touchUpInside).observeValues { [unowned self] (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
//        self.saveButton.reactive.trigger(for: UIControlEvents.touchUpInside).observeValues { [unowned self] (_) in
//            if self.imageView.image == nil {
//                SVProgressHUD.showError(withStatus: "图片未成功下载完")
//                return
//            }
//            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
//
//        self.saveButton.reactive.controlEvents(UIControlEvents.touchUpInside).observeValues { [unowned self](_) in
//            guard let image = self.imageView.image else {
//                SVProgressHUD.showError(withStatus: "图片未成功下载完")
//                return
//            }
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        }
        
        
//        self.saveButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
    }
    
    // MARK: - 按钮监听
//    @IBAction func back(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }

    @IBAction func save(_ sender: UIButton) {
        guard let im = self.imageView.image else {
            SVProgressHUD.showError(withStatus: "图片未下载完")
            return
        }
        UIImageWriteToSavedPhotosAlbum(im, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
//        if self.imageView.image == nil {
//            SVProgressHUD.showError(withStatus: "图片未下载完")
//            return
//        }
//
//        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func savePhoto() {
        guard let im = self.imageView.image else {
            SVProgressHUD.showError(withStatus: "图片未下载完")
            return
        }
        UIImageWriteToSavedPhotosAlbum(im, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    // 保存图片相关
    // Adds a photo to the saved photos album.  The optional completionSelector should have the form:
    //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        } else {
            SVProgressHUD.showError(withStatus: "保存失败")
        }
    }
    
    @objc private func back() {
//        print("back")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - 懒加载
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(back))
        iv.addGestureRecognizer(tap)
        self.scrollView.addSubview(iv)
        
        // 计算图片尺寸
        let width = self.ADScreenW
        let height = width * self.topic!.picHeight / self.topic!.picWidth
        if height > self.ADScreenH {
            iv.frame = CGRect(x: 0, y: 0, width: width, height: height)
            self.scrollView.contentSize = CGSize(width: width, height: height)
        }
        else {
            iv.size = CGSize(width: width, height: height)
            iv.center = CGPoint(x: self.ADScreenW * 0.5, y: self.ADScreenH * 0.5)
        }

        return iv
    }()
    
    
    // MARK: - 构造
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    init(topic: ADTopic?) {
        super.init(nibName: nil, bundle: nil)
        self.topic = topic
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
